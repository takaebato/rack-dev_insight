# frozen_string_literal: true

if defined?(Net) && defined?(Net::HTTP)
  module Net
    class HTTP
      module RackAnalyzer
        def request(request, *args, &)
          Rack::Analyzer::Recorder.new.record_api(request:) { super }
        end
      end

      prepend RackAnalyzer
    end
  end
end
