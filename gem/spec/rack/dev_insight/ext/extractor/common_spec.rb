# frozen_string_literal: true

require 'spec_helper'
require 'rack/dev_insight/ext/extractor/extractor_helper'

RSpec.describe Rack::DevInsight::Extractor::CrudTables do
  describe '.extract' do
    include ExtractorHelper

    subject { described_class.extract(dialect, statement) }

    where(:dialect) do
      [
        Rack::DevInsight::SqlDialects::MYSQL,
        Rack::DevInsight::SqlDialects::POSTGRESQL,
        Rack::DevInsight::SqlDialects::SQLITE,
      ]
    end

    with_them do
      context 'SELECT' do
        context 'SELECT' do
          let(:statement) { 'SELECT a FROM t1' }

          it_behaves_like :extracts_tables, create: [], read: ['t1'], update: [], delete: []
        end

        context 'SELECT with quoted identifier' do
          let(:statement) { 'SELECT a FROM `t1`' }

          it_behaves_like :extracts_tables, create: [], read: ['t1'], update: [], delete: []
        end

        context 'SELECT with uppercase identifier' do
          let(:statement) { 'SELECT a FROM `T1`' }

          it_behaves_like :extracts_tables, create: [], read: ['T1'], update: [], delete: []
        end

        context 'ALIAS' do
          let(:statement) { 'SELECT a FROM t1 AS t1_alias' }

          it_behaves_like :extracts_tables, create: [], read: ['t1'], update: [], delete: []
        end

        context 'WINDOW function' do
          let(:statement) { 'SELECT ROW_NUMBER() OVER(PARTITION BY a ORDER BY b) AS row_num FROM t1' }

          it_behaves_like :extracts_tables, create: [], read: ['t1'], update: [], delete: []
        end

        context 'JOIN ON' do
          let(:statement) { 'SELECT a FROM t1 JOIN t2 ON t1.a = t2.a' }

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2], update: [], delete: []
        end

        context 'JOIN USING' do
          let(:statement) { 'SELECT a FROM t1 JOIN t2 USING (b)' }

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2], update: [], delete: []
        end

        context 'SUB QUERY with COMPARISON' do
          let(:statement) { 'SELECT a FROM t1 WHERE b = (SELECT b FROM t2)' }

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2], update: [], delete: []
        end

        context 'SUB QUERY with IN' do
          let(:statement) { 'SELECT a FROM t1 WHERE b IN (SELECT b FROM t2)' }

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2], update: [], delete: []
        end

        context 'ROW SUB QUERY' do
          let(:statement) { 'SELECT a FROM t1 WHERE (b, c) = (SELECT b, c FROM t2)' }

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2], update: [], delete: []
        end

        context 'SUB QUERY with EXISTS' do
          let(:statement) { 'SELECT a FROM t1 WHERE EXISTS (SELECT * FROM t2)' }

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2], update: [], delete: []
        end

        context 'DERIVED TABLES' do
          let(:statement) { 'SELECT a FROM (SELECT * FROM t1) AS t2' }

          it_behaves_like :extracts_tables, create: [], read: ['t1'], update: [], delete: []
        end

        context 'UNION' do
          let(:statement) { 'SELECT a FROM t1 UNION SELECT a FROM t2' }

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2], update: [], delete: []
        end

        context 'SELECT FOR UPDATE' do
          let(:statement) { 'SELECT a FROM t1 WHERE b = 1 FOR UPDATE' }

          it_behaves_like :extracts_tables, create: [], read: ['t1'], update: [], delete: []
        end

        context 'WITH (Common Table Expressions)' do
          let(:statement) { 'WITH t2 AS (SELECT * FROM t1) SELECT * FROM t2' }

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2], update: [], delete: []
        end
      end

      context 'INSERT' do
        context 'INSERT VALUES' do
          let(:statement) { 'INSERT INTO t1 (a) VALUES (1)' }

          it_behaves_like :extracts_tables, create: ['t1'], read: [], update: [], delete: []
        end

        context 'INSERT VALUES without INTO' do
          let(:statement) { 'INSERT t1 (a) VALUES (1)' }

          it_behaves_like :extracts_tables, create: ['t1'], read: [], update: [], delete: []
        end

        context 'INSERT SELECT' do
          let(:statement) { 'INSERT INTO t1 (a) SELECT a FROM t2' }

          it_behaves_like :extracts_tables, create: ['t1'], read: ['t2'], update: [], delete: []
        end

        context 'INSERT SELECT JOIN' do
          let(:statement) { 'INSERT INTO t1 (a) SELECT a FROM t2 JOIN t3 ON t2.a = t3.a' }

          it_behaves_like :extracts_tables, create: ['t1'], read: %w[t2 t3], update: [], delete: []
        end

        context 'INSERT ON DUPLICATE KEY UPDATE' do
          let(:statement) { 'INSERT INTO t1 (a) VALUES (1) ON DUPLICATE KEY UPDATE a = 1' }

          it_behaves_like :extracts_tables, create: ['t1'], read: [], update: [], delete: []
        end

        describe 'INSERT WITH RETURNING' do
          let(:statement) { 'INSERT INTO t1 (a) VALUES (1) RETURNING a' }

          it_behaves_like :extracts_tables, create: ['t1'], read: [], update: [], delete: []
        end
      end

      context 'UPDATE' do
        context 'UPDATE' do
          let(:statement) { 'UPDATE t1 SET a = 1' }

          it_behaves_like :extracts_tables, create: [], read: [], update: ['t1'], delete: []
        end

        context 'UPDATE JOIN' do
          let(:statement) { 'UPDATE t1 JOIN t2 ON t1.a = t2.a SET t1.b = 1 WHERE t2.b = 1' }

          it_behaves_like :extracts_tables, create: [], read: [], update: %w[t1 t2], delete: []
        end

        context 'UPDATE with ALIAS' do
          let(:statement) do
            'UPDATE t1 AS t1_alias JOIN t2 AS t2_alias ON t1_alias.a = t2_alias.a SET t1_alias.b = 1 WHERE t2_alias.b = 1'
          end

          it_behaves_like :extracts_tables, create: [], read: [], update: %w[t1 t2], delete: []
        end
      end

      context 'DELETE' do
        context 'DELETE' do
          let(:statement) { 'DELETE FROM t1' }

          it_behaves_like :extracts_tables, create: [], read: [], update: [], delete: ['t1']
        end

        context 'DELETE with ALIAS' do
          let(:statement) do
            'DELETE t1_alias FROM t1 AS t1_alias JOIN t2 AS t2_alias ON t1_alias.a = t2_alias.a WHERE t2_alias.b = 1'
          end

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2], update: [], delete: ['t1']
        end

        context 'DELETE multiple tables with JOIN' do
          let(:statement) { 'DELETE t1, t2 FROM t1 INNER JOIN t2 INNER JOIN t3 WHERE t1.a = t2.a AND t2.a = t3.a' }

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2 t3], update: [], delete: %w[t1 t2]
        end

        context 'DELETE multiple tables with USING' do
          let(:statement) do
            'DELETE FROM t1, t2 USING t1 INNER JOIN t2 INNER JOIN t3 WHERE t1.a = t2.a AND t2.a = t3.a'
          end

          it_behaves_like :extracts_tables, create: [], read: %w[t1 t2 t3], update: [], delete: %w[t1 t2]
        end
      end
    end
  end
end
