# frozen_string_literal: true

require 'spec_helper'
require 'rack/dev_insight/ext/extractor/extractor_helper'

RSpec.describe Rack::DevInsight::Extractor do
  describe '.extract' do
    include ExtractorHelper

    subject { described_class.extract_crud_tables(Rack::DevInsight::SqlDialects::MYSQL, statement) }

    context 'SELECT' do
      context 'PARTITION' do
        let(:statement) { 'SELECT a FROM t1 PARTITION (p0)' }

        it_behaves_like :extracts_tables, create: [], read: ['t1'], update: [], delete: []
      end
    end
  end
end
