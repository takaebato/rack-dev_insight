# frozen_string_literal: true

module Rack
  class Analyzer
    class Result
      class Sql
        class Queries
          Query = Struct.new(:id, :statement, :binds, :backtrace, :duration)

          attr_reader :id

          def initialize
            @id = 0
            @data = []
          end

          def add(statement, binds, backtrace, duration)
            @data << Query.new(@id += 1, statement, binds, backtrace, duration)
          end

          def attributes
            @data.map(&:to_h)
          end
        end
      end
    end
  end
end
