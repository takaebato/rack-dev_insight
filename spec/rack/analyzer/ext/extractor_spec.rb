require 'spec_helper'

RSpec.describe Rack::Analyzer::Extractor::CrudTables do
  describe '.extract' do
    subject { described_class.extract(dialect, statement) }

    shared_examples :extracts_tables do |create:, read:, update:, delete:|
      it 'returns crud tables hash' do
        expect(subject).to eq({
                                'CREATE' => create,
                                'READ' => read,
                                'UPDATE' => update,
                                'DELETE' => delete
                              })
      end
    end

    describe 'mysql' do
      let(:dialect) { 'mysql' }

      context 'when valid statement' do
        context 'SELECT' do
          context 'SELECT' do
            let(:statement) { 'SELECT a FROM t1' }

            it_behaves_like :extracts_tables,
                            create: [],
                            read: ['t1'],
                            update: [],
                            delete: []
          end

          context 'SELECT JOIN' do
            let(:statement) { 'SELECT a FROM t1 JOIN t2 ON t1.a = t2.a' }

            it_behaves_like :extracts_tables,
                            create: [],
                            read: ['t1', 't2'],
                            update: [],
                            delete: []
          end

          context 'SELECT FOR UPDATE' do
            let(:statement) { 'SELECT a FROM t1 WHERE b = 1 FOR UPDATE' }

            it_behaves_like :extracts_tables,
                            create: [],
                            read: ['t1'],
                            update: [],
                            delete: []
          end
        end

        context 'INSERT' do
          context 'INSERT' do
            let(:statement) { 'INSERT INTO t1 (a) VALUES (1)' }

            it_behaves_like :extracts_tables,
                            create: ['t1'],
                            read: [],
                            update: [],
                            delete: []
          end

          context 'INSERT SELECT' do
            let(:statement) { 'INSERT INTO t1 (a) SELECT a FROM t2' }

            it_behaves_like :extracts_tables,
                            create: ['t1'],
                            read: ['t2'],
                            update: [],
                            delete: []
          end

          context 'INSERT JOIN' do
            let(:statement) { 'INSERT INTO t1 (a) SELECT a FROM t2 JOIN t3 ON t2.a = t3.a' }

            it_behaves_like :extracts_tables,
                            create: ['t1'],
                            read: ['t2', 't3'],
                            update: [],
                            delete: []
          end
        end

        context 'UPDATE' do
          let(:statement) { 'UPDATE t1 SET a = 1' }

          it_behaves_like :extracts_tables,
                          create: [],
                          read: [],
                          update: ['t1'],
                          delete: []
        end

        context 'DELETE' do
          let(:statement) { 'DELETE FROM t1' }

          it_behaves_like :extracts_tables,
                          create: [],
                          read: [],
                          update: [],
                          delete: ['t1']
        end
      end
    end

    describe 'postgresql' do
      let(:dialect) { 'postgresql' }
    end
    describe 'sqlite' do
      let(:dialect) { 'sqlite' }
    end
  end
end
