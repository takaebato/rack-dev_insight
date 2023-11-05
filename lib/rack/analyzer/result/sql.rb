# Frozen_string_literal: true

require_relative '../rack_analyzer'
require_relative '../ext/extractor'
require_relative '../ext/normalizer'

module Rack
  class Analyzer
    class Result
      class Sql
        class CrudAggregations
          CrudAggregation = Struct.new(:id, :type, :table, :count, :duration, :query_ids)

          def initialize
            @id = 0
            @cached_data = {}
          end

          def add(dialect_name, statement, duration, query_id)
            crud_tables = Extractor::CrudTables.extract(dialect_name, statement)

            crud_tables.each do |type, tables|
              tables.each do |table|
                key = "#{type}_#{table.downcase}"
                data = @cached_data[key] ||= CrudAggregation.new(@id += 1, type, table, 0, 0, [])
                data.count += 1
                data.duration += duration
                data.query_ids << query_id
              end
            end
          end

          def attributes
            @cached_data.values.map(&:to_h)
          end
        end

        class NormalizedAggregations
          NormalizedAggregation = Struct.new(:id, :statement, :count, :duration, :query_ids)

          def initialize
            @id = 0
            @cached_data = {}
          end

          def add(dialect_name, statement, duration, query_id)
            normalized_statement = Normalizer.normalize(dialect_name, statement)

            data = @cached_data[normalized_statement] ||= NormalizedAggregation.new(@id += 1, normalized_statement, 0, 0, [])
            data.count += 1
            data.duration += duration
            data.query_ids << query_id
          end

          def attributes
            @cached_data.values.map(&:to_h)
          end
        end

        class Queries
          Query = Struct.new(:id, :statement, :backtrace, :duration)

          attr_reader :id

          def initialize
            @id = 0
            @data = []
          end

          def add(statement, backtrace, duration)
            @data << Query.new(@id += 1, statement, backtrace, duration)
          end

          def attributes
            @data.map(&:to_h)
          end
        end

        class ErroredQueries
          ErroredQuery = Struct.new(:id, :message, :statement, :backtrace, :duration)

          def initialize
            @data = []
          end

          def add(id, message, statement, backtrace, duration)
            @data << ErroredQuery.new(id, message, statement, backtrace, duration)
          end

          def attributes
            @data.map(&:to_h)
          end
        end

        def initialize
          @crud_aggregations = CrudAggregations.new
          @normalized_aggregations = NormalizedAggregations.new
          @errored_queries = ErroredQueries.new
          @queries = Queries.new
        end

        def add(dialect, statement, backtrace, duration)
          @queries.add(statement, backtrace, duration)
          @crud_aggregations.add(dialect, statement, duration, @queries.id)
          @normalized_aggregations.add(dialect, statement, duration, @queries.id)
        rescue ExtError => e
          @errored_queries.add(@queries.id, e.message, statement, backtrace, duration)
        end

        def attributes
          {
            crud_aggregations: @crud_aggregations.attributes,
            normalized_aggregations: @normalized_aggregations.attributes,
            errored_queries: @errored_queries.attributes,
            queries: @queries.attributes
          }
        end
      end
    end
  end
end
