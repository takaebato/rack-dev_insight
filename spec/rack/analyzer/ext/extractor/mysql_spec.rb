require 'spec_helper'
require 'rack/analyzer/ext/extractor/extractor_helper'

RSpec.describe Rack::Analyzer::Extractor::CrudTables do
  describe '.extract' do
    include ExtractorHelper

    subject { described_class.extract(Rack::Analyzer::SqlDialects::MYSQL, statement) }

    context 'SELECT' do
      context 'PARTITION' do
        let(:statement) { 'SELECT a FROM t1 PARTITION (p0)' }

        it_behaves_like :extracts_tables,
                        create: [],
                        read: ['t1'],
                        update: [],
                        delete: []
      end
    end
  end
end
