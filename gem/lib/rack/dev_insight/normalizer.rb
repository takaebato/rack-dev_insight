# frozen_string_literal: true

module Rack
  class DevInsight
    module Normalizer
      class << self
        def normalize(dialect_name, statement)
          SqlInsight.normalize(dialect_name, statement)
        end
      end
    end
  end
end
