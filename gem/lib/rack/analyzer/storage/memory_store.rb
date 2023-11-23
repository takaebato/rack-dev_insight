# frozen_string_literal: true

module Rack
  class Analyzer
    class MemoryStore
      MAX_REAP_TIME = 2

      def initialize
        @lock = Mutex.new
        @cache = {}
      end

      def write(result)
        @lock.synchronize do
          @cache[result.id] = result
          reap_excess_memory
        end
      end

      def read(id)
        @lock.synchronize { @cache[id] }
      end

      private

      def reap_excess_memory
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        @cache.delete(@cache.keys.first) while memory_excess? && within_reap_time?(start_time)
      end

      def memory_excess?
        bytesize(@cache) > Rack::Analyzer.config.memory_store_size
      end

      def within_reap_time?(start_time)
        Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time < MAX_REAP_TIME
      end

      def bytesize(data)
        Marshal.dump(data).bytesize
      end
    end
  end
end
