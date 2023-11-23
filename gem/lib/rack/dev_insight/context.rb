# frozen_string_literal: true

module Rack
  class DevInsight
    class Context
      class << self
        def current
          Thread.current[:rack_dev_insight_context]
        end

        def create_current(id)
          Thread.current[:rack_dev_insight_context] = new(id)
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
