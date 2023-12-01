# frozen_string_literal: true

if defined?(Mysql2::Client)
  module Mysql2
    class Client
      module RackDevInsight
        def query(*args, &block)
          sql = args[0]
          Rack::DevInsight::SqlRecorder
            .new
            .record_sql(dialect: Rack::DevInsight::SqlDialects::MYSQL, statement: sql) { super }
        end

        def prepare(*args, &block)
          sql = args[0]
          statement = super
          statement.instance_variable_set(:@_rack_dev_insight_sql, sql)
          statement
        end
      end

      prepend RackDevInsight
    end
  end
end

if defined?(Mysql2::Statement)
  module Mysql2
    class Statement
      module RackDevInsight
        def execute(*args, **kwargs)
          params = args
          Rack::DevInsight::SqlRecorder
            .new
            .record_sql(
              dialect: Rack::DevInsight::SqlDialects::MYSQL,
              statement: @_rack_dev_insight_sql || 'Missing prepared statement',
              binds: params,
            ) { super }
        end
      end

      prepend RackDevInsight
    end
  end
end
