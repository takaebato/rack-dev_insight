# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe Rack::DevInsight::Result do
  let(:result) { described_class.new(SecureRandom.uuid) }

  before do
    result.set_request(status: 200, http_method: 'GET', path: '/users', duration: 10.0)
    result.add_sql(
      dialect: 'mysql',
      statement: 'SELECT * FROM users',
      binds: '',
      backtrace: [
        Rack::DevInsight::Result.build_backtrace_item(
          'app/controllers/user_controller.rb:1:in `index`',
          'app/controllers/user_controller.rb',
          1,
        ),
      ],
      duration: 10.0,
    )
    result.add_sql(
      dialect: 'mysql',
      statement: 'SELECT * FROM posts',
      binds: '',
      backtrace: [
        Rack::DevInsight::Result.build_backtrace_item(
          'app/controllers/user_controller.rb:1:in `index`',
          'app/controllers/user_controller.rb',
          1,
        ),
      ],
      duration: 10.0,
    )
    result.add_sql(
      dialect: 'mysql',
      statement: "INSERT INTO users (name) VALUES ('foo')",
      binds: '',
      backtrace: [
        Rack::DevInsight::Result.build_backtrace_item(
          'app/controllers/user_controller.rb:1:in `index`',
          'app/controllers/user_controller.rb',
          1,
        ),
      ],
      duration: 10.0,
    )
    result.add_sql(
      dialect: 'mysql',
      statement: "INSERT INTO users (name) VALUES ('foo')",
      binds: '',
      backtrace: [
        Rack::DevInsight::Result.build_backtrace_item(
          'app/controllers/user_controller.rb:1:in `index`',
          'app/controllers/user_controller.rb',
          1,
        ),
      ],
      duration: 10.0,
    )
    result.add_sql(
      dialect: 'mysql',
      statement: 'INSERT INTO users (name) VALUES', # invalid sql
      binds: '',
      backtrace: [
        Rack::DevInsight::Result.build_backtrace_item(
          'app/controllers/user_controller.rb:1:in `index`',
          'app/controllers/user_controller.rb',
          1,
        ),
      ],
      duration: 10.0,
    )
    result.add_api(
      method: 'GET',
      url: 'http://testhost:80/users',
      request_headers: [Rack::DevInsight::Result.build_header('Content-Type', 'application/json')],
      request_body: nil,
      status: 200,
      response_headers: [Rack::DevInsight::Result.build_header('Content-Type', 'application/json')],
      response_body: { status: 'success' }.to_json,
      backtrace: [
        Rack::DevInsight::Result.build_backtrace_item(
          'app/controllers/user_controller.rb:1:in `index`',
          'app/controllers/user_controller.rb',
          1,
        ),
      ],
      duration: 10.0,
    )
  end

  it 'constructs result' do
    res = result.attributes
    expect(res[:sql][:queries].count).to eq(5)
    expect(res[:sql][:crud_aggregations].count).to eq(3)
    expect(res[:sql][:normalized_aggregations].count).to eq(3)
    expect(res[:sql][:errored_queries].count).to eq(1)
    expect(res[:apis].count).to eq(1)
  end
end
