# frozen_string_literal: true

require_relative 'base_recorder'

module Rack
  class DevInsight
    class ApiRecorder < BaseRecorder
      def record(request:)
        return yield if Context.current.nil?

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        response = yield
        duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        Context.current.result.add_api(
          method: request.method,
          url: request.uri,
          request_headers: request.each_header.map { |field, value| Result.build_header(field, value) },
          request_body: request.body,
          status: response.code.to_i,
          response_headers: response.each_header.map { |field, value| Result.build_header(field, value) },
          response_body: response.body,
          backtrace: get_backtrace,
          duration: format('%.2f', duration * 1000).to_f,
        )
        response
      end
    end
  end
end
