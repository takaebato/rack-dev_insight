# frozen_string_literal: true

if defined?(SQLite3::Statement)
  module SQLite3
    class Statement
      module RackDevInsight
        def initialize(*args, &block)
          @_rack_dev_insight_sql = args[1]
          super
        end

        def bind_params(*bind_vars)
          @_rack_dev_insight_bind_vars = bind_vars
          super
        end

        def each(...)
          Rack::DevInsight::Recorder
            .new
            .record_sql(
              dialect: Rack::DevInsight::SqlDialects::SQLITE,
              statement: @_rack_dev_insight_sql,
              binds: @_rack_dev_insight_bind_vars,
            ) { super }
        end
      end

      prepend RackDevInsight
    end

    class ResultSet
      module RackDevInsight
        def each(...)
          Rack::DevInsight::Recorder
            .new
            .record_sql(
              dialect: Rack::DevInsight::SqlDialects::SQLITE,
              statement: @stmt.instance_variable_get(:@_rack_dev_insight_sql),
              binds: @stmt.instance_variable_get(:@_rack_dev_insight_bind_vars),
            ) { super }
        end
      end

      prepend RackDevInsight
    end
  end
end
