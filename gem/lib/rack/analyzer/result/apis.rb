# frozen_string_literal: true

class Apis
  Api =
    Struct.new(
      :id,
      :method, # rubocop:disable Lint/StructNewOverride
      :url,
      :request_headers,
      :request_body,
      :status,
      :response_headers,
      :response_body,
      :backtrace,
      :duration,
    )
  Header = Struct.new(:field, :value)

  def initialize
    @id = 0
    @data = []
  end

  def add(method, url, request_headers, request_body, status, response_headers, response_body, backtrace, duration)
    @data << Api.new(
      @id += 1,
      method,
      url,
      request_headers.map(&:to_h),
      request_body,
      status,
      response_headers.map(&:to_h),
      response_body,
      backtrace,
      duration,
    )
  end

  def attributes
    @data.map(&:to_h)
  end
end
