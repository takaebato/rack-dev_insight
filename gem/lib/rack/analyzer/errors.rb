# frozen_string_literal: true

module Rack
  class Analyzer
    # Definitions must be synced with ext/rack_analyzer/src/errors.rs
    class Error < StandardError
    end
    class ExtError < Error
    end
    class ParserError < ExtError
    end
  end
end
