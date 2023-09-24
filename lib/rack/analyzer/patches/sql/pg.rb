if defined?(PG::Connection)
  class PG::Connection
    module RackAnalyzer
      def exec(*args, &block)
        Rack::Analyzer::Recorder.new.record_sql(dialect: Rack::Analyzer::SqlDialects::POSTGRESQL, statement: args[0]) do
          super
        end
      end
    end

    prepend RackAnalyzer
  end
end
