if defined?(PG::Connection)
  class PG::Connection
    module RackAnalyzer
      def exec(*args, &block)
        sql = args[0]
        Rack::Analyzer::Recorder.new.record_sql(dialect: Rack::Analyzer::SqlDialects::POSTGRESQL, statement: sql) do
          super
        end
      end

      def async_exec(*args, &block)
        sql = args[0]
        Rack::Analyzer::Recorder.new.record_sql(dialect: Rack::Analyzer::SqlDialects::POSTGRESQL, statement: sql) do
          super
        end
      end

      def exec_params(*args, &blk)
        sql = args[0]
        params = args[1]
        Rack::Analyzer::Recorder.new.record_sql(
          dialect: Rack::Analyzer::SqlDialects::POSTGRESQL,
          statement: sql,
          binds: params
        ) do
          super
        end
      end

      def prepare(*args, &blk)
        name = args[0]
        sql = args[1]
        @_rack_analyzer_prepared_statements ||= {}
        @_rack_analyzer_prepared_statements[name] = sql
        super
      end

      def exec_prepared(*args, &blk)
        name = args[0]
        params = args[1]
        sql = @_rack_analyzer_prepared_statements&.[](name) || missing_statement_message(name)
        Rack::Analyzer::Recorder.new.record_sql(
          dialect: Rack::Analyzer::SqlDialects::POSTGRESQL,
          statement: sql,
          binds: params
        ) do
          super
        end
      end

      def send_query_prepared(*args, &blk)
        name = args[0]
        params = args[1]
        sql = @_rack_analyzer_prepared_statements&.[](name) || missing_statement_message(name)
        Rack::Analyzer::Recorder.new.record_sql(
          dialect: Rack::Analyzer::SqlDialects::POSTGRESQL,
          statement: sql,
          binds: params
        ) do
          super
        end
      end

      private

      def missing_statement_message(name)
        "Missing prepared statement name: #{name}"
      end
    end

    prepend RackAnalyzer
  end
end
