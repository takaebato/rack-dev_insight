require 'spec_helper'
require 'sqlite3'

RSpec.describe 'Patch sqlite' do
  setup_sqlite

  before do
    Rack::Analyzer::Context.create_current(SecureRandom.uuid)
  end

  it 'patches sqlite' do
    expect(defined?(SQLite3::Database::RackAnalyzer)).to eq(nil)
    load 'rack/analyzer/patches/sql/sqlite.rb'
    expect(SQLite3::Database.ancestors.include?(SQLite3::Database::RackAnalyzer)).to eq(true)
    db = sqlite_client
    db.execute("INSERT INTO users (name, email) VALUES ('foo', 'bar@example.com')")
    res = db.execute('SELECT * FROM users WHERE id = 1')
    expect(res.count).to eq(1)
    expect(Rack::Analyzer::Context.current.result.to_h[:sql][:queries].size).to eq(2)
    db.close
  end
end

