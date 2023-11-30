# frozen_string_literal: true

module Rack
  class DevInsight
    class Recorder
      def record_request(http_method:, path:)
        return yield if Context.current.nil?

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        status, headers, body = yield
        duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        Context.current.result.set_request(
          status: status,
          http_method: http_method,
          path: path,
          duration: format('%.2f', duration * 1000).to_f,
        )
        [status, headers, body]
      end

      def record_sql(dialect:, statement:, binds: nil)
        return yield if Context.current.nil?

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        res = yield
        duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        Context.current.result.add_sql(
          dialect: dialect,
          statement: statement,
          binds: format_binds(binds),
          backtrace: get_backtrace,
          duration: format('%.2f', duration * 1000).to_f,
        )
        res
      end

      def record_sql_from_event(started:, finished:, statement:, binds:, cached:)
        return if Context.current.nil?
        return if DevInsight.config.detected_dialect.nil?
        return if DevInsight.config.skip_cached_sql && cached

        Context.current.result.add_sql(
          dialect: DevInsight.config.detected_dialect,
          statement: statement,
          binds: format_binds(binds),
          backtrace: get_backtrace,
          duration: format('%.2f', (finished - started) * 1000).to_f,
        )
      end

      def record_api(request:)
        return yield if Context.current.nil?

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        response = yield
        duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        Context.current.result.add_api(
          method: request.method,
          url: request.uri,
          request_headers: request.each_header.map { |field, value| Result.build_header(field, value) },
          request_body: request.body,
          status: response.code,
          response_headers: response.each_header.map { |field, value| Result.build_header(field, value) },
          response_body: response.body,
          backtrace: get_backtrace,
          duration: format('%.2f', duration * 1000).to_f,
        )
        response
      end

      private

      def format_binds(binds)
        if binds.nil? || binds.try(:empty?) || (binds.is_a?(Array) && binds.all? { _1.try(:empty?) })
          ''
        else
          binds.to_s
        end
      end

      def get_backtrace
        Kernel
          .caller
          .reject { |line| DevInsight.config.backtrace_exclusion_patterns.any? { |regex| line =~ regex } }
          .first(DevInsight.config.backtrace_depth)
          .map do |line|
            if (match = line.match(/(?<path>.*):(?<line>\d+)/))
              Result.build_backtrace_item(line, match[:path], match[:line].to_i)
            end
          end
          .compact
      end
    end
  end
end
