module Rack
  class Analyzer
    class Recorder
      def record_request(http_method:, path:)
        return if Rack::Analyzer::Context.current.nil?

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        status, headers, body = yield
        duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        Rack::Analyzer::Context.current.result.set_request(
          status:,
          http_method:,
          path:,
          duration: sprintf("%.3g", duration * 1000).to_f
        )
        [status, headers, body]
      end

      def record_sql(dialect:, statement:)
        return if Rack::Analyzer::Context.current.nil?

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        res = yield
        duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        Rack::Analyzer::Context.current.result.add_sql(
          dialect:,
          statement:,
          backtrace: get_backtrace,
          duration: sprintf("%.3g", duration * 1000).to_f
        )
        res
      end

      def record_api(request:)
        return if Rack::Analyzer::Context.current.nil?

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        response = yield
        duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        Rack::Analyzer::Context.current.result.add_api(
          method: request.method,
          url: request.uri,
          request_headers: request.each_header.map { |field, value| { field:, value: } },
          request_body: request.body,
          status: response.code,
          response_headers: response.each_header.map { |field, value| { field:, value: } },
          response_body: response.body,
          backtrace: get_backtrace,
          duration: sprintf("%.3g", duration * 1000).to_f
        )
        response
      end

      private

      def get_backtrace
        return [] if Rack::Analyzer.config.skip_backtrace

        Kernel.caller
              .reject { |line| Rack::Analyzer.config.backtrace_exclusion_patterns.any? { |regex| line =~ regex } }
              .first(Rack::Analyzer.config.backtrace_depth)
              .map { |line|
                if (match = line.match(/(?<path>.*):(?<line>\d+)/))
                  { original: line, path: match[:path], line: match[:line].to_i }
                end
              }.compact
      end
    end
  end
end
