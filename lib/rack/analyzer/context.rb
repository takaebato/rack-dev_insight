module Rack
  class Analyzer
    class Context
      class << self
        def current
          Thread.current[:rack_analyzer_context]
        end

        def create_current(id)
          new(id).instance_eval do
            Thread.current[:rack_analyzer_context] = self
          end
        end
      end

      attr_reader :id, :result

      private

      def initialize(id)
        @id = id
        @result = Result.new(id)
      end
    end
  end
end
