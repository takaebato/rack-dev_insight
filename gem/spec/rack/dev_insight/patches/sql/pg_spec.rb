# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Patch pg' do
  setup_postgresql

  # Get results of async queries
  def get_results_of_async_queries(conn)
    results = []
    loop do
      conn.consume_input
      while conn.is_busy # Check if the command is in busy state
        select([conn.socket_io], nil, nil) # Wait till socket is available for read
        conn.consume_input # Read available data from socket and save it in a buffer, clearing the read-ready state of select()
      end
      (res = conn.get_result) or break
      results << res
    end
    results
  end

  before { Rack::DevInsight::Context.create_current(SecureRandom.uuid) }

  it 'patches pg' do
    expect(PG::Connection.ancestors.include?(PG::Connection::RackDevInsight)).to eq(true)
  end

  context 'command without params' do
    context 'sync command' do
      shared_examples 'sync_command' do |method_name|
        it 'records statement' do
          conn = postgres_client
          conn.public_send(method_name, "INSERT INTO users (name, email) VALUES ('foo', 'bar@example.com')")
          res = conn.public_send(method_name, 'SELECT * FROM users')
          expect(res).to be_kind_of(PG::Result)
          expect(res.count).to eq(1)
          expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
          conn.close
        end
      end

      context '#exec' do
        it_behaves_like 'sync_command', :exec
      end

      context '#async_exec' do
        it_behaves_like 'sync_command', :async_exec
      end

      context '#async_query' do
        it_behaves_like 'sync_command', :async_query
      end
    end

    context 'async command' do
      context '#send_query' do
        it 'records statement' do
          conn = postgres_client
          conn.send_query("INSERT INTO users (name, email) VALUES ('foo', 'bar@example.com')")
          get_results_of_async_queries(conn)
          conn.send_query('SELECT * FROM users')
          res = get_results_of_async_queries(conn)
          expect(res.count).to eq(1)
          expect(res[0]).to be_kind_of(PG::Result)
          expect(res[0].count).to eq(1)
          expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
          conn.close
        end
      end
    end
  end

  context 'command with params' do
    context 'sync command' do
      shared_examples 'sync_command_with_params' do |method_name|
        it 'records statement' do
          conn = postgres_client
          conn.public_send(method_name, 'INSERT INTO users (name, email) VALUES ($1, $2)', %w[foo bar@example.com])
          res = conn.public_send(method_name, 'SELECT * FROM users WHERE name = $1', %w[foo])
          expect(res).to be_kind_of(PG::Result)
          expect(res.count).to eq(1)
          expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
          conn.close
        end
      end

      context '#exec_params' do
        it_behaves_like 'sync_command_with_params', :exec_params
      end

      context '#sync_exec_params' do
        it_behaves_like 'sync_command_with_params', :sync_exec_params
      end

      context '#async_exec_params' do
        it_behaves_like 'sync_command_with_params', :async_exec_params
      end
    end

    context 'async command' do
      context '#send_query_params' do
        it 'records statement' do
          conn = postgres_client
          conn.send_query_params('INSERT INTO users (name, email) VALUES ($1, $2)', %w[foo bar@example.com])
          get_results_of_async_queries(conn)
          conn.send_query_params('SELECT * FROM users WHERE name = $1', %w[foo])
          res = get_results_of_async_queries(conn)
          expect(res.count).to eq(1)
          expect(res[0]).to be_kind_of(PG::Result)
          expect(res[0].count).to eq(1)
          expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
          conn.close
        end
      end
    end
  end

  context 'prepared statements' do
    shared_examples 'prepared_statement' do |prepare_method, exec_method, is_prepared_async, is_exec_async|
      it 'records statement' do
        conn = postgres_client
        conn.public_send(prepare_method, 'insert1', 'INSERT INTO users (name, email) VALUES ($1, $2)')
        get_results_of_async_queries(conn) if is_prepared_async
        conn.public_send(exec_method, 'insert1', %w[foo bar@example.com])
        get_results_of_async_queries(conn) if is_exec_async
        conn.public_send(prepare_method, 'select1', 'SELECT * FROM users WHERE name = $1')
        get_results_of_async_queries(conn) if is_prepared_async
        res = conn.public_send(exec_method, 'select1', %w[foo])
        res = get_results_of_async_queries(conn).first if is_exec_async
        expect(res).to be_kind_of(PG::Result)
        expect(res.count).to eq(1)
        expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(2)
        conn.close
      end
    end

    context '#prepare' do
      it_behaves_like 'prepared_statement', :prepare, :exec_prepared, false, false
      it_behaves_like 'prepared_statement', :prepare, :async_exec_prepared, false, false
      it_behaves_like 'prepared_statement', :prepare, :sync_exec_prepared, false, false
      it_behaves_like 'prepared_statement', :prepare, :send_query_prepared, false, true
    end

    context '#sync_prepare' do
      it_behaves_like 'prepared_statement', :sync_prepare, :exec_prepared, false, false
      it_behaves_like 'prepared_statement', :sync_prepare, :async_exec_prepared, false, false
      it_behaves_like 'prepared_statement', :sync_prepare, :sync_exec_prepared, false, false
      it_behaves_like 'prepared_statement', :sync_prepare, :send_query_prepared, false, true
    end

    context '#async_prepare' do
      it_behaves_like 'prepared_statement', :async_prepare, :exec_prepared, false, false
      it_behaves_like 'prepared_statement', :async_prepare, :async_exec_prepared, false, false
      it_behaves_like 'prepared_statement', :async_prepare, :sync_exec_prepared, false, false
      it_behaves_like 'prepared_statement', :async_prepare, :send_query_prepared, false, true
    end

    context '#send_prepare' do
      it_behaves_like 'prepared_statement', :send_prepare, :exec_prepared, true, false
      it_behaves_like 'prepared_statement', :send_prepare, :async_exec_prepared, true, false
      it_behaves_like 'prepared_statement', :send_prepare, :sync_exec_prepared, true, false
      it_behaves_like 'prepared_statement', :send_prepare, :send_query_prepared, true, true
    end
  end

  context 'multi statements' do
    it 'records multi statements' do
      conn = postgres_client
      res =
        conn.exec(
          "INSERT INTO users (name, email) VALUES ('foo', 'bar@example.com');" \
            "UPDATE users SET name = 'foo2' WHERE name = 'foo';" \
            'SELECT * FROM users',
        )
      expect(res).to be_kind_of(PG::Result)
      expect(res.count).to eq(1)
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(1)
      conn.close
    end
  end
end
