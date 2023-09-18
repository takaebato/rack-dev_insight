# frozen_string_literal: true

require 'json'
require_relative 'result/request'
require_relative 'result/sql'

module Rack
  class Analyzer
    class Result
      attr_reader :id

      def initialize(id)
        @id = id
        @request = Request.new
        @sql = Sql.new
      end

      def set_request_if_unset(status:, method:, path:, endpoint:, duration:)
        @request.set(status, method, path, endpoint, duration) unless @request.set?
      end

      def add_sql(name:, statement:, backtrace:, duration:, cached:)
        @sql.add(name, statement, backtrace, duration, cached)
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
