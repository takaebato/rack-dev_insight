# frozen_string_literal: true

require 'spec_helper'
require 'mysql2'

RSpec.describe 'Patch mysql2' do
  setup_mysql

  before { Rack::DevInsight::Context.create_current(SecureRandom.uuid) }

  it 'patches mysql2' do
    load 'rack/dev_insight/patches/sql/mysql2.rb'
    expect(Mysql2::Client.ancestors.include?(Mysql2::Client::RackDevInsight)).to eq(true)
    expect(Mysql2::Statement.ancestors.include?(Mysql2::Statement::RackDevInsight)).to eq(true)
  end

  context 'single statement' do
    it 'records single statement' do
      load 'rack/dev_insight/patches/sql/mysql2.rb'
      c = mysql_client
      c.query('INSERT INTO users (name, email) VALUES ("foo", "bar@example.com")')
      res = c.query('SELECT * FROM users WHERE id = 1')
      expect(res).to be_kind_of(Mysql2::Result)
      expect(res.count).to eq(1)
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
      c.close
    end
  end

  context 'prepared statements' do
    it 'records prepared statements' do
      load 'rack/dev_insight/patches/sql/mysql2.rb'
      c = mysql_client
      statement1 = c.prepare('INSERT INTO users (name, email) VALUES (?, ?)')
      statement1.execute('foo', 'bar@example.com')
      statement2 = c.prepare('SELECT * FROM users WHERE name LIKE ?')
      res = statement2.execute('foo')
      expect(res).to be_kind_of(Mysql2::Result)
      expect(res.count).to eq(1)
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
      c.close
    end
  end

  context 'multi statements' do
    it 'records multi statements' do
      load 'rack/dev_insight/patches/sql/mysql2.rb'
      c = mysql_client(flags: Mysql2::Client::MULTI_STATEMENTS)
      res = c.query('INSERT INTO users (name, email) VALUES ("foo", "bar@example.com"); SELECT * FROM users')
      expect(res).to be_nil
      while c.next_result
        res = c.store_result
        expect(res).to be_kind_of(Mysql2::Result)
        expect(res.count).to eq(1)
      end
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(1)
      c.close
    end
  end
end
