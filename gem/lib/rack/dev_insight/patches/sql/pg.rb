# frozen_string_literal: true

if defined?(PG::Connection)
  module PG
    class Connection
      module RackDevInsight
        def exec(*args, &block)
          sql = args[0]
          Rack::DevInsight::Recorder
            .new
            .record_sql(dialect: Rack::DevInsight::SqlDialects::POSTGRESQL, statement: sql) { super }
        end

        def async_exec(*args, &block)
          sql = args[0]
          Rack::DevInsight::Recorder
            .new
            .record_sql(dialect: Rack::DevInsight::SqlDialects::POSTGRESQL, statement: sql) { super }
        end

        def exec_params(*args, &block)
          sql = args[0]
          params = args[1]
          Rack::DevInsight::Recorder
            .new
            .record_sql(dialect: Rack::DevInsight::SqlDialects::POSTGRESQL, statement: sql, binds: params) { super }
        end

        def prepare(*args, &block)
          name = args[0]
          sql = args[1]
          @_rack_dev_insight_prepared_statements ||= {}
          while Rack::DevInsight.config.prepared_statement_limit <= @_rack_dev_insight_prepared_statements.size
            @_rack_dev_insight_prepared_statements.shift
          end
          @_rack_dev_insight_prepared_statements[name] = sql
          super
        end

        def exec_prepared(*args, &block)
          name = args[0]
          params = args[1]
          sql = @_rack_dev_insight_prepared_statements&.[](name) || missing_statement_message(name)
          Rack::DevInsight::Recorder
            .new
            .record_sql(dialect: Rack::DevInsight::SqlDialects::POSTGRESQL, statement: sql, binds: params) { super }
        end

        def send_query_prepared(*args, &block)
          name = args[0]
          params = args[1]
          sql = @_rack_dev_insight_prepared_statements&.[](name) || missing_statement_message(name)
          Rack::DevInsight::Recorder
            .new
            .record_sql(dialect: Rack::DevInsight::SqlDialects::POSTGRESQL, statement: sql, binds: params) { super }
        end

        private

        def missing_statement_message(name)
          "Missing prepared statement name: #{name}"
        end
      end

      prepend RackDevInsight
    end
  end
end
