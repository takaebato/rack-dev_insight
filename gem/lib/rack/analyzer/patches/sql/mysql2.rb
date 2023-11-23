# frozen_string_literal: true

if defined?(Mysql2::Client)
  module Mysql2
    class Client
      module RackAnalyzer
        def query(*args, &)
          sql = args[0]
          Rack::Analyzer::Recorder.new.record_sql(dialect: Rack::Analyzer::SqlDialects::MYSQL, statement: sql) { super }
        end

        def prepare(*args, &)
          sql = args[0]
          statement = super
          statement.instance_variable_set(:@_rack_analyzer_sql, sql)
          statement
        end
      end

      prepend RackAnalyzer
    end
  end
end

if defined?(Mysql2::Statement)
  module Mysql2
    class Statement
      module RackAnalyzer
        def execute(*args, **kwargs)
          params = args
          Rack::Analyzer::Recorder
            .new
            .record_sql(
              dialect: Rack::Analyzer::SqlDialects::MYSQL,
              statement: @_rack_analyzer_sql || 'Missing prepared statement',
              binds: params,
            ) { super }
        end
      end

      prepend RackAnalyzer
    end
  end
end
