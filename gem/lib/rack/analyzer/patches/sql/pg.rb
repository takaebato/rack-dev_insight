# frozen_string_literal: true

if defined?(PG::Connection)
  module PG
    class Connection
      module RackAnalyzer
        def exec(*args, &)
          sql = args[0]
          Rack::Analyzer::Recorder
            .new
            .record_sql(dialect: Rack::Analyzer::SqlDialects::POSTGRESQL, statement: sql) { super }
        end

        def async_exec(*args, &)
          sql = args[0]
          Rack::Analyzer::Recorder
            .new
            .record_sql(dialect: Rack::Analyzer::SqlDialects::POSTGRESQL, statement: sql) { super }
        end

        def exec_params(*args, &)
          sql = args[0]
          params = args[1]
          Rack::Analyzer::Recorder
            .new
            .record_sql(dialect: Rack::Analyzer::SqlDialects::POSTGRESQL, statement: sql, binds: params) { super }
        end

        def prepare(*args, &)
          name = args[0]
          sql = args[1]
          @_rack_analyzer_prepared_statements ||= {}
          @_rack_analyzer_prepared_statements[name] = sql
          super
        end

        def exec_prepared(*args, &)
          name = args[0]
          params = args[1]
          sql = @_rack_analyzer_prepared_statements&.[](name) || missing_statement_message(name)
          Rack::Analyzer::Recorder
            .new
            .record_sql(dialect: Rack::Analyzer::SqlDialects::POSTGRESQL, statement: sql, binds: params) { super }
        end

        def send_query_prepared(*args, &)
          name = args[0]
          params = args[1]
          sql = @_rack_analyzer_prepared_statements&.[](name) || missing_statement_message(name)
          Rack::Analyzer::Recorder
            .new
            .record_sql(dialect: Rack::Analyzer::SqlDialects::POSTGRESQL, statement: sql, binds: params) { super }
        end

        private

        def missing_statement_message(name)
          "Missing prepared statement name: #{name}"
        end
      end

      prepend RackAnalyzer
    end
  end
end
