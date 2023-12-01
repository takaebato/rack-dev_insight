# frozen_string_literal: true

require 'securerandom'
require_relative 'dev_insight/version'
require_relative 'dev_insight/rack_dev_insight'
require_relative 'dev_insight/storage/memory_store'
require_relative 'dev_insight/storage/file_store'
require_relative 'dev_insight/result'
require_relative 'dev_insight/recorder/api_recorder'
require_relative 'dev_insight/recorder/request_recorder'
require_relative 'dev_insight/recorder/sql_recorder'
require_relative 'dev_insight/config'
require_relative 'dev_insight/context'
require_relative 'dev_insight/errors'
require_relative 'dev_insight/sql_dialects'

require_relative 'dev_insight/railtie' if defined?(Rails)
unless defined?(Rack::DevInsight::DISABLE_SQL_PATCH)
  require_relative 'dev_insight/patches/sql/mysql2'
  require_relative 'dev_insight/patches/sql/pg'
end
require_relative 'dev_insight/patches/api/net_http' unless defined?(Rack::DevInsight::DISABLE_NET_HTTP_PATCH)

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
        RequestRecorder.new.record(http_method: request.request_method, path: request.path) { @app.call(env) }
      @storage.write(Context.current.result)
      headers['X-Rack-Dev-Insight-Id'] = Context.current.id

      [status, headers, body]
    end
  end
end
