module Rack
  class Analyzer
    class Config
      attr_accessor :storage, :storage_instance

      def initialize
        @storage = MemoryStore
      end
    end
  end
end
