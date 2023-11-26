# frozen_string_literal: true

if !defined?(Rack::DevInsight::DISABLE_NET_HTTP_PATCH) && (defined?(Net) && defined?(Net::HTTP))
  module Net
    class HTTP
      module RackDevInsight
        def request(request, *args, &block)
          Rack::DevInsight::Recorder.new.record_api(request: request) { super }
        end
      end

      prepend RackDevInsight
    end
  end
end
