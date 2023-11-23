# frozen_string_literal: true

module Rack
  class Analyzer
    class Result
      class Sql
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
      end
    end
  end
end
