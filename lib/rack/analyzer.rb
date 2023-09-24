# frozen_string_literal: true

require 'securerandom'
require_relative "analyzer/version"
require_relative "analyzer/rack_analyzer"
require_relative "analyzer/storage/memory_store"
require_relative "analyzer/result"
require_relative "analyzer/recorder"
require_relative "analyzer/config"
require_relative "analyzer/context"
require_relative "analyzer/errors"
require_relative 'analyzer/patches/sql/mysql2'
require_relative 'analyzer/patches/sql/pg'
require_relative 'analyzer/patches/sql/sqlite'
require_relative 'analyzer/patches/api/net_http'

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

    SQL_DIALECT_MYSQL = 'mysql'
    SQL_DIALECT_POSTGRESQL = 'postgresql'
    SQL_DIALECT_SQLITE = 'sqlite'

    def initialize(app)
      @app = app
      @config = Analyzer.config
      @config.storage_instance ||= @config.storage.new
      @storage = @config.storage_instance
      Context.create_current(SecureRandom.uuid)
    end

    def call(env)
      if (id = env['PATH_INFO'][%r{/rack-analyzer-results/(.+)$}, 1])
        fetch_analyzed(id)
      else
        analyze(env)
      end
    end

    private

    def fetch_analyzed(id)
      header = { 'Content-Type' => 'application/json' }
      if (result = @storage.read(id))
        [200, header, result.to_response_json]
      else
        [404, header, { status: 404, message: "id: #{id} is not found" }.to_json]
      end
    rescue StandardError => e
      [500, header, { status: 500, message: e.inspect }.to_json]
    end

    def analyze(env)
      request = Rack::Request.new(env)
      status, headers, body = Recorder.new.record_request(http_method: request.request_method, path: request.path) do
        @app.call(env)
      end
      @storage.write(Context.current.result)
      headers['X-RackAnalyzer-Id'] = Context.current.id

      [status, headers, body]
    end
  end
end
