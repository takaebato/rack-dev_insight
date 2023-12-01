# frozen_string_literal: true

if defined?(Net) && defined?(Net::HTTP)
  module Net
    class HTTP
      module RackDevInsight
        def request(request, *args, &block)
          Rack::DevInsight::ApiRecorder.new.record(request: request) { super }
        end
      end

      prepend RackDevInsight
    end
  end
end
