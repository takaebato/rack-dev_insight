if defined?(SQLite3::Statement)
  class SQLite3::Statement
    module RackAnalyzer
      def initialize(*args, &block)
        @_rack_analyzer_sql = args[1]
        super
      end

      def bind_params(*bind_vars)
        @_rack_analyzer_bind_vars = bind_vars
        super
      end

      def each(...)
        Rack::Analyzer::Recorder.new.record_sql(
          dialect: Rack::Analyzer::SqlDialects::SQLITE,
          statement: @_rack_analyzer_sql,
          binds: @_rack_analyzer_bind_vars
        ) do
          super
        end
      end
    end

    prepend RackAnalyzer
  end
end
