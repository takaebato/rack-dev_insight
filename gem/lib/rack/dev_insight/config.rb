# frozen_string_literal: true

module Rack
  class DevInsight
    class Config
      attr_accessor :storage_type,
                    :memory_store_size,
                    :file_store_pool_size,
                    :file_store_dir_path,
                    :skip_paths,
                    :backtrace_exclusion_patterns,
                    :backtrace_depth,
                    :prepared_statement_limit,
                    :skip_cached_sql,
                    :detected_dialect

      def initialize
        @storage_type = :memory
        @memory_store_size = 32 * 1024 * 1024
        @file_store_pool_size = 100
        @file_store_dir_path = 'tmp/rack-dev_insight'
        @skip_paths = []
        @backtrace_depth = 5
        @backtrace_exclusion_patterns = [%r{/gems/}]
        @prepared_statement_limit = 1000
        @skip_cached_sql = true
      end

      def storage_instance
        case storage_type.to_sym
        when :memory
          MemoryStore.new
        when :file
          FileStore.new
        else
          warn "warning: Unknown storage type: #{storage_type} in Rack::DevInsight::Config. " \
                 'Available types are :memory and :file. Falling back to :memory.'
          MemoryStore.new
        end
      end
    end
  end
end
