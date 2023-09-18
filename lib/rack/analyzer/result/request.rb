module Rack
  class Analyzer
    class Result
      class Request
        def initialize
          @data = {}
          @is_set = false
        end

        def set(status, method, path, endpoint, duration)
          @data = {
            status: status,
            method: method,
            path: path,
            endpoint: endpoint,
            duration: duration
          }
          @is_set = true
        end

        def set?
          @is_set
        end

        def to_h
          @data
        end
      end
    end
  end
end
