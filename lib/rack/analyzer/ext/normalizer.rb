# frozen_string_literal: true

module Rack
  class Analyzer
    module Normalizer
      class << self
        def normalize(dialect_name, statement)
          _normalize(dialect_name, statement)
        end
      end
    end
  end
end
