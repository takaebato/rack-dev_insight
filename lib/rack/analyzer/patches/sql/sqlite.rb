if defined?(SQLite3::Database)
  class SQLite3::Database
    module RackAnalyzer
      def execute(*args, &block)
        Rack::Analyzer::Recorder.new.record_sql(dialect: Rack::Analyzer::SQL_DIALECT_SQLITE, statement: args[0]) do
          super
        end
      end
    end

    prepend RackAnalyzer
  end
end
