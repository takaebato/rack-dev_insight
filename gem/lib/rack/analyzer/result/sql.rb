# Frozen_string_literal: true

require_relative 'sql/crud_aggregations'
require_relative 'sql/normalized_aggregations'
require_relative 'sql/errored_queries'
require_relative 'sql/queries'

module Rack
  class Analyzer
    class Result
      class Sql
        def initialize
          @crud_aggregations = CrudAggregations.new
          @normalized_aggregations = NormalizedAggregations.new
          @errored_queries = ErroredQueries.new
          @queries = Queries.new
        end

        def add(dialect, statement, binds, backtrace, duration)
          @queries.add(statement, binds, backtrace, duration)
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
