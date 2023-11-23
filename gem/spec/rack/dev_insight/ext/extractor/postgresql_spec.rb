# frozen_string_literal: true

require 'spec_helper'
require 'rack/dev_insight/ext/extractor/extractor_helper'

RSpec.describe Rack::DevInsight::Extractor::CrudTables do
  describe '.extract' do
    include ExtractorHelper

    subject { described_class.extract(Rack::DevInsight::SqlDialects::POSTGRESQL, statement) }

    describe 'INSERT ON CONFLICT' do
      let(:statement) { 'INSERT INTO t1 (a) VALUES (1) ON CONFLICT (a) DO NOTHING' }

      it_behaves_like :extracts_tables, create: ['t1'], read: [], update: [], delete: []
    end
  end
end
