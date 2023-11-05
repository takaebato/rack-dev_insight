class Apis
  Api = Struct.new(:id, :method, :url, :request_headers, :request_body, :status, :response_headers, :response_body, :backtrace, :duration)

  def initialize
    @id = 0
    @data = []
  end

  def add(method, url, request_headers, request_body, status, response_headers, response_body, backtrace, duration)
    @data << Api.new(@id += 1, method, url, request_headers, request_body, status, response_headers, response_body, backtrace, duration)
  end

  def attributes
    @data.map(&:to_h)
  end
end

