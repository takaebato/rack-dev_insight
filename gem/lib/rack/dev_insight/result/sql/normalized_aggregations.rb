# frozen_string_literal: true

require_relative '../../ext/normalizer'

module Rack
  class DevInsight
    class Result
      class Sql
        class NormalizedAggregations
          NormalizedAggregation = Struct.new(:id, :statement, :count, :duration, :query_ids) # rubocop:disable Lint/StructNewOverride

          def initialize
            @id = 0
            @cached_data = {}
          end

          def add(dialect_name, statement, duration, query_id)
            normalized_statements = Normalizer.normalize(dialect_name, statement)
            normalized_statement = normalized_statements.join('; ')

            data =
              @cached_data[normalized_statement] ||= NormalizedAggregation.new(@id += 1, normalized_statement, 0, 0, [])
            data.count += 1
            data.duration += duration
            data.query_ids << query_id
          end

          def attributes
            @cached_data.values.map do |data|
              data.duration = format('%.2f', data.duration).to_f
              data.to_h
            end
          end
        end
      end
    end
  end
end
