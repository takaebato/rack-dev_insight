# frozen_string_literal: true

module Rack
  class DevInsight
    # Definitions must be synced with ext/rack_dev_insight/src/errors.rs
    class Error < StandardError
    end
    class ExtError < Error
    end
    class ParserError < ExtError
    end
  end
end
