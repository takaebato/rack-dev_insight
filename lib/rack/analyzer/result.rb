# frozen_string_literal: true

require 'json'
require_relative 'result/request'
require_relative 'result/sql'

module Rack
  class Analyzer
    class Result
      def initialize(id)
        @id = id
        @request = Request.new
        @sql = Sql.new
      end

      def add_request(status:, method:, path:, endpoint:, duration:)
        @request.add(status, method, path, endpoint, duration)
      end

      def add_sql(name:, statement:, stack_trace:, duration:, cached:)
        @sql.add(name, statement, stack_trace, duration, cached)
      end

      def to_h
        {
          id: @id,
          request: @request.to_h,
          sql: @sql.to_h
        }
      end

      def to_json
        to_h.to_json
      end
    end
  end
end
