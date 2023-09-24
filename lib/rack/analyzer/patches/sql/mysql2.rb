if defined?(Mysql2::Client)
  class Mysql2::Client
    module RackAnalyzer
      def query(*args, &block)
        Rack::Analyzer::Recorder.new.record_sql(dialect: Rack::Analyzer::SqlDialects::MYSQL, statement: args[0]) do
          super
        end
      end
    end

    prepend RackAnalyzer
  end
end
