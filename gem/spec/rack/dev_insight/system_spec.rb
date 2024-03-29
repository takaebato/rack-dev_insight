# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::DevInsight do
  include Rack::Test::Methods
  include Committee::Test::Methods

  setup_mysql
  setup_postgresql

  def app
    Rack::Builder
      .new do
        use Rack::DevInsight
        run lambda { |_env|
              c = mysql_client
              c.query("INSERT INTO users (name, email) VALUES ('foo1', 'bar1@example.com')")
              conn = postgres_client
              conn.exec("INSERT INTO users (name, email) VALUES ('foo2', 'bar2@example.com'); SELECT * FROM users")
              uri =
                URI("http://#{ENV.fetch('MOCK_HTTP_SERVER_HOST', nil)}:#{ENV.fetch('MOCK_HTTP_SERVER_PORT', nil)}/get")
              Net::HTTP.get_response(uri)

              [200, { 'Content-Type' => 'application/json' }, [{ status: 'success' }.to_json]]
            }
      end
      .to_app
  end

  def committee_options
    @committee_options ||= { schema: Committee::Drivers.load_from_file('../openapi/openapi.yaml') }
  end

  def request_object
    last_request
  end

  def response_data
    [last_response.status, last_response.headers, last_response.body]
  end

  before { Rack::DevInsight.config.storage_type = :file }

  it 'records and returns analyzed result' do
    get '/app'
    expect(last_response.status).to eq(200)
    rack_dev_insight_id = last_response.headers['X-Rack-Dev-Insight-Id']
    expect(rack_dev_insight_id).not_to be_nil

    get "/rack-dev-insight-results/#{rack_dev_insight_id}"
    assert_response_schema_confirm(200)
    result = JSON.parse(last_response.body)
    expect(result['sql']['queries'].size).to eq(2)
    expect(result['apis'].size).to eq(1)

    get '/rack-dev-insight-results/dummy-uuid'
    assert_response_schema_confirm(404)
  end
end
