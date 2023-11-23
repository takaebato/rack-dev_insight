# frozen_string_literal: true

require 'spec_helper'
require 'pg'

RSpec.describe 'Patch pg' do
  setup_postgresql

  before { Rack::DevInsight::Context.create_current(SecureRandom.uuid) }

  it 'patches pg' do
    expect(defined?(PG::Connection::RackDevInsight)).to eq(nil)
    load 'rack/dev_insight/patches/sql/pg.rb'
    expect(PG::Connection.ancestors.include?(PG::Connection::RackDevInsight)).to eq(true)
    conn = postgres_client
    conn.exec("INSERT INTO users (name, email) VALUES ('foo', 'bar@example.com')")
    res = conn.exec('SELECT * FROM users WHERE id = 1')
    expect(res).to be_kind_of(PG::Result)
    expect(res.count).to eq(1)
    expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
    conn.close
  end
end
