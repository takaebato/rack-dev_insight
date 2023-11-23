# frozen_string_literal: true

require 'securerandom'
require_relative 'dev_insight/config'
require_relative 'dev_insight/context'
require_relative 'dev_insight/recorder'

module Rack
  class DevInsight
    class << self
      def configure
        yield config
      end

      def config
        @config ||= Config.new
      end
    end

    def initialize(app)
      @app = app
      @config = DevInsight.config
      @config.storage_instance ||= @config.storage.new
      @storage = @config.storage_instance
    end

    def call(env)
      if (id = get_id_from_path(env))
        fetch_analyzed(id)
      else
        analyze(env)
      end
    end

    private

    def get_id_from_path(env)
      env['PATH_INFO'][%r{/rack-dev-insight-results/(.+)$}, 1]
    end

    def fetch_analyzed(id)
      header = { 'Content-Type' => 'application/json' }
      if (result = @storage.read(id))
        [200, header, [result.to_response_json]]
      else
        [404, header, [{ status: 404, message: "id: #{id} is not found" }.to_json]]
      end
    rescue StandardError => e
      [500, header, [{ status: 500, message: e.inspect }.to_json]]
    end

    def analyze(env)
      Context.create_current(SecureRandom.uuid)
      request = Rack::Request.new(env)
      status, headers, body =
        Recorder.new.record_request(http_method: request.request_method, path: request.path) { @app.call(env) }
      @storage.write(Context.current.result)
      headers['X-Rack-Dev-Insight-Id'] = Context.current.id

      [status, headers, body]
    end
  end
end
