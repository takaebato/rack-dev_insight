# frozen_string_literal: true

if defined?(SQLite3::Statement)
  module SQLite3
    class Statement
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
          Rack::Analyzer::Recorder
            .new
            .record_sql(
              dialect: Rack::Analyzer::SqlDialects::SQLITE,
              statement: @_rack_analyzer_sql,
              binds: @_rack_analyzer_bind_vars,
            ) { super }
        end
      end

      prepend RackAnalyzer
    end

    class ResultSet
      module RackAnalyzer
        def each(...)
          Rack::Analyzer::Recorder
            .new
            .record_sql(
              dialect: Rack::Analyzer::SqlDialects::SQLITE,
              statement: @stmt.instance_variable_get(:@_rack_analyzer_sql),
              binds: @stmt.instance_variable_get(:@_rack_analyzer_bind_vars),
            ) { super }
        end
      end

      prepend RackAnalyzer
    end
  end
end
