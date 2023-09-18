# frozen_string_literal: true

require 'test_helper'

class RackAnalyzerTest < ActionDispatch::IntegrationTest
  test 'it works' do
    post '/users', params: { user: { email: 'test@example.com' } }
    expect(response).to be_ok
    expect(response.body).to eq 'Hello World'
    id = response.headers['x-rackanalyzer-id']
    get "/rack_analyzer_results/#{id}"
    expect(response).to be_ok
    expect(response.body).to eq Rack::Analyzer::Result.new(id).to_json
  end
end
