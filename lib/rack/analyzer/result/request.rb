module Rack
  class Analyzer
    class Result
      class Request
        def initialize
          @data = {}
        end

        def add(status, method, path, endpoint, duration)
          @data = {
            status: status,
            method: method,
            path: path,
            endpoint: endpoint,
            duration: duration
          }
        end

        def to_h
          @data
        end
      end
    end
  end
end
