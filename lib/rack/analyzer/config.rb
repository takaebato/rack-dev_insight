module Rack
  class Analyzer
    class Config
      attr_accessor :storage, :storage_instance, :skip_backtrace, :backtrace_exclusion_patterns

      def initialize
        @storage = MemoryStore
        @skip_backtrace = false
        @backtrace_exclusion_patterns = [/rack-analyzer/]
      end
    end
  end
end
