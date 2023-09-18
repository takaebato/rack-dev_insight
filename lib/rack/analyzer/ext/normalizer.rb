# frozen_string_literal: true

module Rack
  class Analyzer
    module Normalizer
      class << self
        def normalize(dialect_name, statement)
          _normalize(dialect_name, statement)
        rescue ParserError => err
          raise ExtError
        end
      end
    end
  end
end
