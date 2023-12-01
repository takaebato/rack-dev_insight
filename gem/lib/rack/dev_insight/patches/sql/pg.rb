# frozen_string_literal: true

if defined?(PG::Connection)
  module PG
    class Connection
      module RackDevInsight
        %i[exec sync_exec async_exec async_query send_query].each do |method_name|
          define_method(method_name) do |*args, &block|
            sql = args[0]
            Rack::DevInsight::SqlRecorder
              .new
              .record_sql(dialect: Rack::DevInsight::SqlDialects::POSTGRESQL, statement: sql) { super(*args, &block) }
          end
        end

        %i[exec_params sync_exec_params async_exec_params send_query_params].each do |method_name|
          define_method(method_name) do |*args, &block|
            sql = args[0]
            params = args[1]
            Rack::DevInsight::SqlRecorder
              .new
              .record_sql(dialect: Rack::DevInsight::SqlDialects::POSTGRESQL, statement: sql, binds: params) do
                super(*args, &block)
              end
          end
        end

        %i[prepare sync_prepare async_prepare send_prepare].each do |method_name|
          define_method(method_name) do |*args, &block|
            name = args[0]
            sql = args[1]
            @_rack_dev_insight_prepared_statements ||= {}
            # Remove the oldest prepared statement if limit is reached
            while Rack::DevInsight.config.prepared_statement_limit <= @_rack_dev_insight_prepared_statements.size
              @_rack_dev_insight_prepared_statements.shift
            end
            @_rack_dev_insight_prepared_statements[name] = sql
            super(*args, &block)
          end
        end

        # Assume one of the above prepare methods was called before
        %i[exec_prepared sync_exec_prepared async_exec_prepared send_query_prepared].each do |method_name|
          define_method(method_name) do |*args, &block|
            name = args[0]
            params = args[1]
            sql = @_rack_dev_insight_prepared_statements&.[](name) || missing_statement_message(name)
            Rack::DevInsight::SqlRecorder
              .new
              .record_sql(dialect: Rack::DevInsight::SqlDialects::POSTGRESQL, statement: sql, binds: params) do
                super(*args, &block)
              end
          end
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
