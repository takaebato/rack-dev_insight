# frozen_string_literal: true

require 'securerandom'
require_relative "analyzer/version"
require_relative "analyzer/rack_analyzer"
require_relative "analyzer/storage/memory_store"
require_relative "analyzer/result"
require_relative "analyzer/config"
require_relative "analyzer/context"

module Rack
  class Analyzer
    class Error < StandardError; end

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
      id = env['PATH_INFO'][%r{/rack_analyzer_results/(.+)$}, 1]
      if id
        serve_result(id)
      else
        status, headers, body = @app.call(env)
        @storage.write(Context.current.result)
        headers['X-RackAnalyzer-Id'] = Context.current.id
        [status, headers, body]
      end
    end

    private

    def serve_result(id)
      [200, { 'Content-Type' => 'application/json' }, @storage.read(id)&.to_json || '']
    end
  end
end
