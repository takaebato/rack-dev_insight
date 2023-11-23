# frozen_string_literal: true

module Rack
  class DevInsight
    module Camelizer
      module_function

      def camelize_keys(value)
        case value
        when Array
          value.map { |v| camelize_keys(v) }
        when Hash
          value.transform_keys { |key| to_camel_case(key.to_s) }.transform_values { |v| camelize_keys(v) }
        else
          value
        end
      end

      def to_camel_case(str)
        str.gsub(/_([a-z])/) { ::Regexp.last_match(1).upcase }
      end
    end
  end
end
