# frozen_string_literal: true

module Rack
  class DevInsight
    class Result
      class Sql
        class CrudAggregations
          CrudAggregation = Struct.new(:id, :type, :table, :count, :duration, :query_ids) # rubocop:disable Lint/StructNewOverride

          def initialize
            @id = 0
            @cached_data = {}
          end

          def add(dialect_name, statement, duration, query_id)
            crud_tables = Extractor.extract_crud_tables(dialect_name, statement)

            crud_tables.each do |type, tables|
              tables.each do |table|
                key = "#{type}_#{table}"
                data = @cached_data[key] ||= CrudAggregation.new(@id += 1, type, table, 0, 0, [])
                data.count += 1
                data.duration += duration
                data.query_ids << query_id
              end
            end
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
