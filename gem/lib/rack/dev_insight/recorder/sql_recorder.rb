# frozen_string_literal: true

require_relative 'base_recorder'

module Rack
  class DevInsight
    class SqlRecorder < BaseRecorder
      class << self
        # @param [String] dialect 'mysql', 'postgresql' or 'sqlite' are supported
        # @param [String] statement SQL statement
        # @param [Array] binds SQL statement binds
        # @param [Float] duration milliseconds of SQL execution time
        # @return [nil]
        def record(dialect:, statement:, binds: [], duration: 0.0)
          new.record(dialect: dialect, statement: statement, binds: binds, duration: duration)
        end
      end

      def record(dialect:, statement:, binds: [], duration: 0.0)
        SqlDialects.validate!(dialect, ArgumentError)
        return if Context.current.nil?

        Context.current.result.add_sql(
          dialect: dialect,
          statement: statement,
          binds: format_binds(binds),
          backtrace: get_backtrace,
          duration: format('%.2f', duration).to_f,
        )
        nil
      end

      def record_sql(dialect:, statement:, binds: [])
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

      def record_from_event(started:, finished:, statement:, binds:, cached:)
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
        nil
      end
    end
  end
end
