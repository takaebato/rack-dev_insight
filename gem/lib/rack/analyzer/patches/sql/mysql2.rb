if defined?(Mysql2::Client)
  class Mysql2::Client
    module RackAnalyzer
      def query(*args, &block)
        sql = args[0]
        Rack::Analyzer::Recorder.new.record_sql(dialect: Rack::Analyzer::SqlDialects::MYSQL, statement: sql) do
          super
        end
      end

      def prepare(*args, &block)
        sql = args[0]
        statement = super
        statement.instance_variable_set(:@_rack_analyzer_sql, sql)
        statement
      end
    end

    prepend RackAnalyzer
  end
end

if defined?(Mysql2::Statement)
  class Mysql2::Statement
    module RackAnalyzer
      def execute(*args, **kwargs)
        params = args
        Rack::Analyzer::Recorder.new.record_sql(
          dialect: Rack::Analyzer::SqlDialects::MYSQL,
          statement: @_rack_analyzer_sql || 'Missing prepared statement',
          binds: params
        ) do
          super
        end
      end
    end

    prepend RackAnalyzer
  end
end
