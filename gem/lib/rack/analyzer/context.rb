module Rack
  class Analyzer
    class Context
      class << self
        def current
          Thread.current[:rack_analyzer_context]
        end

        def create_current(id)
          Thread.current[:rack_analyzer_context] = new(id)
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
