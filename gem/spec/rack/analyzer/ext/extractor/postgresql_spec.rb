require 'spec_helper'
require 'rack/analyzer/ext/extractor/extractor_helper'

RSpec.describe Rack::Analyzer::Extractor::CrudTables do
  describe '.extract' do
    include ExtractorHelper

    subject { described_class.extract(Rack::Analyzer::SqlDialects::POSTGRESQL, statement) }

    describe 'INSERT ON CONFLICT' do
      let(:statement) { 'INSERT INTO t1 (a) VALUES (1) ON CONFLICT (a) DO NOTHING' }

      it_behaves_like :extracts_tables,
                      create: ['t1'],
                      read: [],
                      update: [],
                      delete: []
    end
  end
end
