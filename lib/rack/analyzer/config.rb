module Rack
  class Analyzer
    class Config
      attr_accessor :storage, :file_store_pool_size, :storage_instance, :skip_backtrace, :backtrace_exclusion_patterns, :backtrace_depth

      def initialize
        @storage = MemoryStore
        @file_store_pool_size = 100
        @skip_backtrace = false
        @backtrace_exclusion_patterns = [/rack-analyzer/]
        @backtrace_depth = 5
      end
    end
  end
end
