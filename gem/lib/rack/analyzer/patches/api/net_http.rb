if defined?(Net) && defined?(Net::HTTP)
  class Net::HTTP
    module RackAnalyzer
      def request(request, *args, &block)
        Rack::Analyzer::Recorder.new.record_api(request:) do
          super
        end
      end
    end

    prepend RackAnalyzer
  end
end
