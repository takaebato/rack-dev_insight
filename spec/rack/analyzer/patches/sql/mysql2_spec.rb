require 'spec_helper'
require 'mysql2'

RSpec.describe 'Patch mysql2' do
  setup_mysql

  before do
    Rack::Analyzer::Context.create_current(SecureRandom.uuid)
  end

  it 'patch mysql2' do
    expect(defined?(Mysql2::Client::RackAnalyzer)).to eq(nil)
    load 'rack/analyzer/patches/sql/mysql2.rb'
    expect(Mysql2::Client.ancestors.include?(Mysql2::Client::RackAnalyzer)).to eq(true)
    c = mysql_client
    c.query('INSERT INTO users (name, email) VALUES ("foo", "bar@example.com")')
    res = c.query('SELECT * FROM users WHERE id = 1')
    expect(res).to be_kind_of(Mysql2::Result)
    expect(res.count).to eq(1)
    expect(Rack::Analyzer::Context.current.result.to_h[:sql][:queries].size).to eq(2)
    c.close
  end
end

