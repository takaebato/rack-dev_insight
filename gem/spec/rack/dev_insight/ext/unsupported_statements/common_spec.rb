# frozen_string_literal: true

require 'spec_helper'
require 'rack/dev_insight/ext/extractor/extractor_helper'

RSpec.describe 'List unsupported statements' do
  include ExtractorHelper

  # use CrudTables extractor to parse statements
  subject { Rack::DevInsight::Extractor::CrudTables.extract(dialect, statement) }

  shared_examples :not_parseable do
    it 'raises parser error' do
      expect { subject }.to raise_error(Rack::DevInsight::ParserError)
    end
  end

  where(:dialect) do
    [
      Rack::DevInsight::SqlDialects::MYSQL,
      Rack::DevInsight::SqlDialects::POSTGRESQL,
      Rack::DevInsight::SqlDialects::SQLITE,
    ]
  end

  with_them do
    context 'SELECT' do
      context 'SUB QUERY with COMPARISON and ALL' do
        let(:statement) { 'SELECT a FROM t1 WHERE b > ALL (SELECT b FROM t2)' }

        it_behaves_like :not_parseable
      end
    end

    context 'INSERT' do
      # https://github.com/sqlparser-rs/sqlparser-rs/issues/295
      context 'INSERT SET' do
        let(:statement) { 'INSERT INTO t1 SET a = 1' }

        it_behaves_like :not_parseable
      end
    end

    context 'UPDATE' do
      # https://github.com/sqlparser-rs/sqlparser-rs/issues/295
      context 'UPDATE with ORDER BY and LIMIT' do
        let(:statement) { 'UPDATE t1 SET a = 1 ORDER BY a LIMIT 1' }

        it_behaves_like :not_parseable
      end

      context 'UPDATE multiple tables' do
        let(:statement) { 'UPDATE t1, t2 SET t1.a = 1, t2.b = 2' }

        it_behaves_like :not_parseable
      end
    end

    context 'DELETE' do
      context 'DELETE IGNORE' do
        let(:statement) { 'DELETE IGNORE FROM t1' }

        it_behaves_like :extracts_tables, create: [], read: ['t1'], update: [], delete: ['IGNORE'] # IGNORE should not be included as table name
      end
    end

    context 'TABLE' do
      let(:statement) { 'TABLE t1' }

      it_behaves_like :not_parseable
    end
  end
end
