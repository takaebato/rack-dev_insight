# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe Rack::Analyzer::Result do
  let(:result) { described_class.new(SecureRandom.uuid) }

  before do
    result.set_request(
      status: 200,
      http_method: 'GET',
      path: '/users',
      duration: 10.0
    )
    result.add_sql(
      dialect: 'mysql',
      statement: "SELECT * FROM users",
      backtrace: ['app/controllers/user_controller.rb:1:in `index`'],
      duration: 10.0
    )
    result.add_sql(
      dialect: 'mysql',
      statement: "SELECT * FROM posts",
      backtrace: ['app/controllers/user_controller.rb:1:in `index`'],
      duration: 10.0
    )
    result.add_sql(
      dialect: 'mysql',
      statement: "INSERT INTO users (name) VALUES ('foo')",
      backtrace: ['app/controllers/user_controller.rb:1:in `index`'],
      duration: 10.0
    )
    result.add_sql(
      dialect: 'mysql',
      statement: "INSERT INTO users (name) VALUES ('foo')",
      backtrace: ['app/controllers/user_controller.rb:1:in `index`'],
      duration: 10.0
    )
    result.add_api(
      method: 'GET',
      url: 'http://localhost:8080/users',
      request_headers: { 'Content-Type' => 'application/json' },
      request_body: nil,
      status: 200,
      response_headers: { 'Content-Type' => 'application/json' },
      response_body: { status: 'success' }.to_json,
      backtrace: ['app/controllers/user_controller.rb:1:in `index`'],
      duration: 10.0
    )
  end

  it 'constructs result' do
    res = result.to_h
    expect(res[:sql][:crud_aggregations].count).to eq(2)
    expect(res[:sql][:normalized_aggregations].count).to eq(3)
    expect(res[:apis].count).to eq(1)
  end
end
