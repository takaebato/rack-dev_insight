# frozen_string_literal: true

require_relative './base_recorder'

module Rack
  class DevInsight
    class RequestRecorder < BaseRecorder
      def record(http_method:, path:)
        return yield if Context.current.nil?

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        status, headers, body = yield
        duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        Context.current.result.set_request(
          status: status,
          http_method: http_method,
          path: path,
          duration: format('%.2f', duration * 1000).to_f,
        )
        [status, headers, body]
      end
    end
  end
end
