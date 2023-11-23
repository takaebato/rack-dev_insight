# frozen_string_literal: true
require 'spec_helper'
require 'rack/analyzer/ext/normalizer/normalizer_helper'

RSpec.describe Rack::Analyzer::Normalizer do
  describe '.normalize' do
    include NormalizerHelper

    subject { described_class.normalize(dialect, statement) }

    where(:dialect) do
      [Rack::Analyzer::SqlDialects::MYSQL, Rack::Analyzer::SqlDialects::POSTGRESQL, Rack::Analyzer::SqlDialects::SQLITE]
    end

    with_them do
      context 'SELECT' do
        context 'WHERE' do
          let(:statement) { 'SELECT a FROM t1 WHERE b = 1 and c in (1, 2) and d IS NULL' }
          let(:normalized) { 'SELECT a FROM t1 WHERE b = ? AND c IN (?, ?) AND d IS NULL' }

          it_behaves_like :normalize
        end

        context 'ORDER BY' do
          let(:statement) { 'SELECT a FROM t1 ORDER BY a' }
          let(:normalized) { 'SELECT a FROM t1 ORDER BY a' }

          it_behaves_like :normalize
        end

        context 'LIMIT, OFFSET' do
          let(:statement) { 'SELECT a FROM t1 WHERE b = 1 LIMIT 1 OFFSET 1' }
          let(:normalized) { 'SELECT a FROM t1 WHERE b = ? LIMIT ? OFFSET ?' }

          it_behaves_like :normalize
        end

        context 'GROUP BY, HAVING' do
          let(:statement) { 'SELECT a FROM t1 GROUP BY a HAVING a > 1' }
          let(:normalized) { 'SELECT a FROM t1 GROUP BY a HAVING a > ?' }

          it_behaves_like :normalize
        end

        context 'ALIAS' do
          let(:statement) { 'SELECT a FROM t1 AS t1_alias' }
          let(:normalized) { 'SELECT a FROM t1 AS t1_alias' }

          it_behaves_like :normalize
        end

        context 'WINDOW function' do
          let(:statement) { 'SELECT ROW_NUMBER() OVER (PARTITION BY a ORDER BY b) AS row_num FROM t1' }
          let(:normalized) { 'SELECT ROW_NUMBER() OVER (PARTITION BY a ORDER BY b) AS row_num FROM t1' }

          it_behaves_like :normalize
        end

        context 'JOIN ON' do
          let(:statement) { 'SELECT a FROM t1 JOIN t2 ON t1.a = t2.a AND t2.b > 1' }
          let(:normalized) { 'SELECT a FROM t1 JOIN t2 ON t1.a = t2.a AND t2.b > ?' }

          it_behaves_like :normalize
        end

        context 'JOIN USING' do
          let(:statement) { 'SELECT a FROM t1 JOIN t2 USING (b)' }
          let(:normalized) { 'SELECT a FROM t1 JOIN t2 USING(b)' }

          it_behaves_like :normalize
        end

        context 'SUB QUERY with COMPARISON' do
          let(:statement) { 'SELECT a FROM t1 WHERE b = (SELECT b FROM t2)' }
          let(:normalized) { 'SELECT a FROM t1 WHERE b = (SELECT b FROM t2)' }

          it_behaves_like :normalize
        end

        context 'SUB QUERY with IN' do
          let(:statement) { 'SELECT a FROM t1 WHERE b IN (SELECT b FROM t2)' }
          let(:normalized) { 'SELECT a FROM t1 WHERE b IN (SELECT b FROM t2)' }

          it_behaves_like :normalize
        end

        context 'ROW SUB QUERY' do
          let(:statement) { 'SELECT a FROM t1 WHERE (b, c) = (SELECT b, c FROM t2)' }
          let(:normalized) { 'SELECT a FROM t1 WHERE (b, c) = (SELECT b, c FROM t2)' }

          it_behaves_like :normalize
        end

        context 'SUB QUERY with EXISTS' do
          let(:statement) { 'SELECT a FROM t1 WHERE EXISTS (SELECT * FROM t2)' }
          let(:normalized) { 'SELECT a FROM t1 WHERE EXISTS (SELECT * FROM t2)' }

          it_behaves_like :normalize
        end

        context 'DERIVED TABLES' do
          let(:statement) { 'SELECT a FROM (SELECT * FROM t1) AS t2' }
          let(:normalized) { 'SELECT a FROM (SELECT * FROM t1) AS t2' }

          it_behaves_like :normalize
        end

        context 'UNION' do
          let(:statement) { 'SELECT a FROM t1 UNION SELECT a FROM t2' }
          let(:normalized) { 'SELECT a FROM t1 UNION SELECT a FROM t2' }

          it_behaves_like :normalize
        end

        context 'SELECT FOR UPDATE' do
          let(:statement) { 'SELECT a FROM t1 WHERE b = 1 FOR UPDATE' }
          let(:normalized) { 'SELECT a FROM t1 WHERE b = ? FOR UPDATE' }

          it_behaves_like :normalize
        end

        context 'WITH (Common Table Expressions)' do
          let(:statement) { 'WITH t2 AS (SELECT * FROM t1) SELECT * FROM t2' }
          let(:normalized) { 'WITH t2 AS (SELECT * FROM t1) SELECT * FROM t2' }

          it_behaves_like :normalize
        end
      end

      context 'INSERT' do
        context 'INSERT VALUES' do
          let(:statement) { 'INSERT INTO t1 (a, b) VALUES (1, 2)' }
          let(:normalized) { 'INSERT INTO t1 (a, b) VALUES (?, ?)' }

          it_behaves_like :normalize
        end

        context 'INSERT VALUES without INTO' do
          let(:statement) { 'INSERT t1 (a, b) VALUES (1, 2)' }
          let(:normalized) { 'INSERT t1 (a, b) VALUES (?, ?)' }

          it_behaves_like :normalize
        end

        context 'INSERT SELECT' do
          let(:statement) { 'INSERT INTO t1 (a) SELECT a FROM t2 WHERE b > 1' }
          let(:normalized) { 'INSERT INTO t1 (a) SELECT a FROM t2 WHERE b > ?' }

          it_behaves_like :normalize
        end

        context 'INSERT SELECT JOIN' do
          let(:statement) { 'INSERT INTO t1 (a) SELECT a FROM t2 JOIN t3 ON t2.a = t3.a' }
          let(:normalized) { 'INSERT INTO t1 (a) SELECT a FROM t2 JOIN t3 ON t2.a = t3.a' }

          it_behaves_like :normalize
        end

        context 'INSERT ON DUPLICATE KEY UPDATE' do
          let(:statement) { 'INSERT INTO t1 (a) VALUES (1) ON DUPLICATE KEY UPDATE a = 1' }
          let(:normalized) { 'INSERT INTO t1 (a) VALUES (?) ON DUPLICATE KEY UPDATE a = ?' }

          it_behaves_like :normalize
        end
      end

      context 'UPDATE' do
        context 'UPDATE' do
          let(:statement) { 'UPDATE t1 SET a = 1' }
          let(:normalized) { 'UPDATE t1 SET a = ?' }

          it_behaves_like :normalize
        end

        context 'UPDATE JOIN' do
          let(:statement) { 'UPDATE t1 JOIN t2 ON t1.a = t2.a SET t1.b = 1 WHERE t2.b = 1' }
          let(:normalized) { 'UPDATE t1 JOIN t2 ON t1.a = t2.a SET t1.b = ? WHERE t2.b = ?' }

          it_behaves_like :normalize
        end

        context 'UPDATE with ALIAS' do
          let(:statement) do
            'UPDATE t1 AS t1_alias JOIN t2 AS t2_alias ON t1_alias.a = t2_alias.a SET t1_alias.b = 1 WHERE t2_alias.b = 1'
          end
          let(:normalized) do
            'UPDATE t1 AS t1_alias JOIN t2 AS t2_alias ON t1_alias.a = t2_alias.a SET t1_alias.b = ? WHERE t2_alias.b = ?'
          end

          it_behaves_like :normalize
        end
      end

      context 'DELETE' do
        context 'DELETE' do
          let(:statement) { 'DELETE FROM t1' }
          let(:normalized) { 'DELETE FROM t1' }

          it_behaves_like :normalize
        end

        context 'DELETE with ALIAS' do
          let(:statement) do
            'DELETE t1_alias FROM t1 AS t1_alias JOIN t2 AS t2_alias ON t1_alias.a = t2_alias.a WHERE t2_alias.b = 1'
          end
          let(:normalized) do
            'DELETE t1_alias FROM t1 AS t1_alias JOIN t2 AS t2_alias ON t1_alias.a = t2_alias.a WHERE t2_alias.b = ?'
          end

          it_behaves_like :normalize
        end

        context 'DELETE multiple tables with JOIN' do
          let(:statement) { 'DELETE t1, t2 FROM t1 JOIN t2 JOIN t3 WHERE t1.a = t2.a AND t2.a = t3.a' }
          let(:normalized) { 'DELETE t1, t2 FROM t1 JOIN t2 JOIN t3 WHERE t1.a = t2.a AND t2.a = t3.a' }

          it_behaves_like :normalize
        end

        context 'DELETE multiple tables with USING' do
          let(:statement) { 'DELETE FROM t1, t2 USING t1 JOIN t2 JOIN t3 WHERE t1.a = t2.a AND t2.a = t3.a' }
          let(:normalized) { 'DELETE FROM t1, t2 USING t1 JOIN t2 JOIN t3 WHERE t1.a = t2.a AND t2.a = t3.a' }

          it_behaves_like :normalize
        end
      end
    end
  end
end
