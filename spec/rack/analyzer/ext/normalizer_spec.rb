require 'spec_helper'

RSpec.describe Rack::Analyzer::Normalizer do
  describe '.normalize' do
    shared_examples :normalize do |statement, normalized|
      it 'returns normalized statement' do
        expect(described_class.normalize(dialect, statement)).to eq(normalized)
      end
    end

    describe 'mysql' do
      let(:dialect) { 'mysql' }

      context 'when valid statement' do
        context 'SELECT' do
          context 'SELECT' do
            it_behaves_like :normalize,
                            'SELECT a FROM t1 WHERE b = 1 AND c IN (1, 2, 3) AND d LIKE "%foo%"',
                            'SELECT a FROM t1 WHERE b = ? AND c IN (?, ?, ?) AND d LIKE ?'
          end

          context 'SELECT WITH JOIN' do
            it_behaves_like :normalize,
                            'SELECT a FROM t1 INNER JOIN t2 ON t1.a = t2.a WHERE b = 1',
                            'SELECT a FROM t1 INNER JOIN t2 ON t1.a = t2.a WHERE b = ?'
          end
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

