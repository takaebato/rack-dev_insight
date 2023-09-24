module Rack
  class Analyzer
    class Config
      attr_accessor :storage, :memory_store_size, :file_store_pool_size, :storage_instance, :skip_backtrace, :backtrace_exclusion_patterns, :backtrace_depth

      def initialize
        @storage = MemoryStore
        @memory_store_size = 32 * 1024 * 1024
        @file_store_pool_size = 100
        @skip_backtrace = false
        @backtrace_exclusion_patterns = [/rack-analyzer/]
        @backtrace_depth = 5
      end
    end
  end
end
