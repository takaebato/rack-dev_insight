# frozen_string_literal: true

require 'spec_helper'
require 'mysql2'

RSpec.describe 'Patch mysql2' do
  setup_mysql

  before { Rack::DevInsight::Context.create_current(SecureRandom.uuid) }

  it 'patch mysql2' do
    expect(defined?(Mysql2::Client::RackDevInsight)).to eq(nil)
    load 'rack/dev_insight/patches/sql/mysql2.rb'
    expect(Mysql2::Client.ancestors.include?(Mysql2::Client::RackDevInsight)).to eq(true)
    c = mysql_client
    c.query('INSERT INTO users (name, email) VALUES ("foo", "bar@example.com")')
    res = c.query('SELECT * FROM users WHERE id = 1')
    expect(res).to be_kind_of(Mysql2::Result)
    expect(res.count).to eq(1)
    expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
    c.close
  end
end
