module Rack
  class Analyzer
    class MemoryStore
      def initialize
        @lock = Mutex.new
        @cache = {}
      end

      def write(data)
        @lock.synchronize do
          @cache[data[:id]] = data
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
