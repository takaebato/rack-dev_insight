# frozen_string_literal: true

module Rack
  class DevInsight
    class Config
      attr_accessor :storage,
                    :storage_instance,
                    :memory_store_size,
                    :file_store_pool_size,
                    :file_store_dir_path,
                    :skip_backtrace,
                    :backtrace_exclusion_patterns,
                    :backtrace_depth

      def initialize
        @storage = MemoryStore
        @memory_store_size = 32 * 1024 * 1024
        @file_store_pool_size = 100
        @file_store_dir_path = 'tmp/rack-dev-insight'
        @skip_backtrace = false
        @backtrace_exclusion_patterns = [/rack-dev-insight/]
        @backtrace_depth = 5
      end
    end
  end
end
