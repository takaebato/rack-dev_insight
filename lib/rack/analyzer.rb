# frozen_string_literal: true

require 'securerandom'
require_relative "analyzer/version"
require_relative "analyzer/rack_analyzer"
require_relative "analyzer/storage/memory_store"
require_relative "analyzer/result"
require_relative "analyzer/config"
require_relative "analyzer/context"
require_relative "analyzer/errors"

if defined?(::Rails)
  require_relative 'analyzer/rails/railtie'
end

module Rack
  class Analyzer
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
      @config = Analyzer.config
      @config.storage_instance ||= @config.storage.new
      @storage = @config.storage_instance
      Context.create_current(SecureRandom.uuid)
    end

    def call(env)
      if (id = env['PATH_INFO'][%r{/rack_analyzer_results/(.+)$}, 1])
        fetch_analyzed(id)
      else
        analyzing(env) { @app.call(env) }
      end
    end

    private

    def fetch_analyzed(id)
      [200, { 'Content-Type' => 'application/json' }, @storage.read(id)&.to_json || '']
    end

    def analyzing(env)
      request = Rack::Request.new(env)
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      status, headers, body = yield
      Context.current.result.set_request_if_unset(
        status: status,
        method: request.request_method,
        path: request.path,
        endpoint: '',
        duration: Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
      )
      @storage.write(Context.current.result)
      headers['X-RackAnalyzer-Id'] = Context.current.id

      [status, headers, body]
    end
  end
end
