module Rack
  class Analyzer
    class MemoryStore
      def initialize
        @lock = Mutex.new
        @cache = {}
      end

      def write(result)
        @lock.synchronize do
          @cache[result.id] = result
        end
      end

      def read(id)
        @lock.synchronize do
          @cache[id]
        end
      end
    end
  end
end
