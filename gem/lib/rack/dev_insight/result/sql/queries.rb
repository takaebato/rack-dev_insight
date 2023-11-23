# frozen_string_literal: true

module Rack
  class DevInsight
    class Result
      class Sql
        class Queries
          Query = Struct.new(:id, :statement, :binds, :backtrace, :duration)
          TraceInfo = Struct.new(:original, :path, :line)

          attr_reader :id

          def initialize
            @id = 0
            @data = []
          end

          def add(statement, binds, backtrace, duration)
            @data << Query.new(@id += 1, statement, binds, backtrace.map(&:to_h), duration)
          end

          def attributes
            @data.map(&:to_h)
          end
        end
      end
    end
  end
end
