# Frozen_string_literal: true

require_relative '../rack_analyzer'
require_relative '../ext/extractor'
require_relative '../ext/normalizer'

module Rack
  class Analyzer
    class Result
      class Sql
        class CrudAggregations
          CrudAggregation = Struct.new(:type, :table, :count, :duration, :query_ids)

          def initialize
            @cached_data = {}
          end

          def add(dialect_name, statement, duration, query_id, errored_queries)
            crud_tables = begin
                            Extractor::CrudTables.extract(dialect_name, statement)
                          rescue ExtError => e
                            errored_queries << ErroredQuery.new(query_id, e.message)
                            return
                          end

            crud_tables.each do |type, tables|
              tables.each do |table|
                key = "#{type}_#{table.downcase}"
                data = @cached_data[key] ||= CrudAggregation.new(type, table, 0, 0, [])
                data.count += 1
                data.duration += duration
                data.query_ids << query_id
              end
            end
          end

          def to_a
            @cached_data.values.map(&:to_h)
          end
        end

        class NormalizedAggregations
          NormalizedAggregation = Struct.new(:statement, :count, :duration, :query_ids)

          def initialize
            @cached_data = {}
          end

          def add(dialect_name, statement, duration, query_id, errored_queries)
            normalized_statement = begin
                                     Normalizer.normalize(dialect_name, statement)
                                   rescue ExtError => e
                                     errored_queries << ErroredQuery.new(query_id, e.message)
                                     return
                                   end

            data = @cached_data[normalized_statement] ||= NormalizedAggregation.new(normalized_statement, 0, 0, [])
            data.count += 1
            data.duration += duration
            data.query_ids << query_id
          end

          def to_a
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

          def to_a
            @data.map(&:to_h)
          end
        end

        ErroredQuery = Struct.new(:query_id, :message)

        def initialize
          @crud_aggregations = CrudAggregations.new
          @normalized_aggregations = NormalizedAggregations.new
          @errored_queries = []
          @queries = Queries.new
        end

        def add(dialect, statement, backtrace, duration)
          @queries.add(statement, backtrace, duration)
          @crud_aggregations.add(dialect, statement, duration, @queries.id, @errored_queries)
          @normalized_aggregations.add(dialect, statement, duration, @queries.id, @errored_queries)
        end

        def to_h
          {
            crud_aggregations: @crud_aggregations.to_a,
            normalized_aggregations: @normalized_aggregations.to_a,
            errored_queries: @errored_queries.map(&:to_h).uniq,
            queries: @queries.to_a
          }
        end
      end
    end
  end
end
