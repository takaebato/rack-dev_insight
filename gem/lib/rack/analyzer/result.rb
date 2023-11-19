# frozen_string_literal: true

require 'json'
require_relative 'result/sql'
require_relative 'result/apis'
require_relative 'utils/camelizer'

module Rack
  class Analyzer
    class Result
      Request = Struct.new(:status, :http_method, :path, :duration)

      attr_reader :id

      def initialize(id)
        @id = id
        @request = Request.new
        @sql = Sql.new
        @apis = Apis.new
      end

      def set_request(status:, http_method:, path:, duration:)
        @request = Request.new(status, http_method, path, duration)
      end

      def add_sql(dialect:, statement:, binds:, backtrace:, duration:)
        @sql.add(dialect, statement, binds, backtrace, duration)
      end

      def add_api(method:, url:, request_headers:, request_body:, status:, response_headers:, response_body:, backtrace:, duration:)
        @apis.add(method, url, request_headers, request_body, status, response_headers, response_body, backtrace, duration)
      end

      def attributes
        {
          id: @id,
          status: @request.status,
          method: @request.http_method,
          path: @request.path,
          duration: @request.duration,
          sql: @sql.attributes,
          apis: @apis.attributes
        }
      end

      def to_response_json
        Camelizer.camelize_keys(attributes).to_json
      end
    end
  end
end
