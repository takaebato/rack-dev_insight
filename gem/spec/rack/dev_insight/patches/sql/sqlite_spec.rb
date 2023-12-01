# frozen_string_literal: true

require 'spec_helper'
require 'sqlite3'

RSpec.describe 'Patch sqlite' do
  setup_sqlite

  before { Rack::DevInsight::Context.create_current(SecureRandom.uuid) }

  it 'patches sqlite' do
    expect(defined?(SQLite3::Statement::RackDevInsight)).to eq(nil)
    load 'rack/dev_insight/patches/sql/sqlite.rb'
    expect(SQLite3::Statement.ancestors.include?(SQLite3::Statement::RackDevInsight)).to eq(true)
  end

  context 'command without params' do
    it 'records statement' do
      load 'rack/dev_insight/patches/sql/sqlite.rb'
      db = sqlite_client
      db.execute("INSERT INTO users (name, email) VALUES ('foo', 'bar@example.com')")
      res = db.execute('SELECT * FROM users WHERE id = 1')
      expect(res.count).to eq(1)
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
      db.close
    end
  end

  context 'command with params' do
    it 'records statement' do
      load 'rack/dev_insight/patches/sql/sqlite.rb'
      db = sqlite_client
      db.execute('INSERT INTO users (name, email) VALUES (?, ?)', %w[foo bar@example.com])
      res = db.execute('SELECT * FROM users WHERE id = ?', [1])
      expect(res.count).to eq(1)
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
      db.close
    end
  end

  context 'prepared statements' do
    it 'records prepared statements' do
      load 'rack/dev_insight/patches/sql/sqlite.rb'
      db = sqlite_client
      statement1 = db.prepare('INSERT INTO users (name, email) VALUES (?, ?)')
      statement1.execute('foo', 'bar@example.com')
      statement2 = db.prepare('SELECT * FROM users WHERE name LIKE ?')
      res = statement2.execute('foo')
      expect(res.count).to eq(1)
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
    end
  end
end
