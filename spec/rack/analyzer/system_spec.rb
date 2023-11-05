# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require 'rack'
require 'mysql2'
require 'pg'
require 'sqlite3'
require 'net/http'

RSpec.describe Rack::Analyzer do
  include Rack::Test::Methods
  include Committee::Test::Methods

  setup_mysql
  setup_postgresql
  setup_sqlite

  def app
    Rack::Builder.new do
      use Rack::Analyzer
      run lambda { |_env|
        load 'rack/analyzer/patches/api/net_http.rb'
        load 'rack/analyzer/patches/sql/mysql2.rb'
        load 'rack/analyzer/patches/sql/pg.rb'
        load 'rack/analyzer/patches/sql/sqlite.rb'

        c = mysql_client
        c.query('INSERT INTO users (name, email) VALUES ("foo1", "bar1@example.com")')
        conn = postgres_client
        conn.exec("INSERT INTO users (name, email) VALUES ('foo2', 'bar2@example.com')")
        db = sqlite_client
        db.execute("INSERT INTO users (name, email) VALUES ('foo3', 'bar3@example.com')")
        uri = URI('http://localhost:8080/get')
        Net::HTTP.get_response(uri)

        [200, { 'Content-Type' => 'application/json' }, { status: 'success' }.to_json]
      }
    end.to_app
  end

  def committee_options
    @committee_options ||= { schema: Committee::Drivers.load_from_file('apidoc/openapi.yaml') }
  end

  def request_object
    last_request
  end

  def response_data
    [last_response.status, last_response.headers, last_response.body]
  end

  before do
    Rack::Analyzer.configure do |config|
      config.storage = Rack::Analyzer::FileStore
    end
  end

  it 'records and returns analyzed result' do
    get '/app'
    expect(last_response.status).to eq(200)
    rack_analyzer_id = last_response.headers['X-RackAnalyzer-Id']
    expect(rack_analyzer_id).not_to be_nil

    get "/rack-analyzer-results/#{rack_analyzer_id}"
    assert_response_schema_confirm(200)
    result = JSON.parse(last_response.body)
    expect(result['sql']['queries'].size).to eq(3)
    expect(result['apis'].size).to eq(1)

    get '/rack-analyzer-results/dummy-uuid'
    assert_response_schema_confirm(404)
  end
end
