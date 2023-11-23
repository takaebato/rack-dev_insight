# frozen_string_literal: true
require 'spec_helper'
require 'rack/analyzer/ext/extractor/extractor_helper'

RSpec.describe 'List unsupported statements' do
  include ExtractorHelper

  # use CrudTables extractor to parse statements
  subject { Rack::Analyzer::Extractor::CrudTables.extract(Rack::Analyzer::SqlDialects::POSTGRESQL, statement) }

  shared_examples :not_parseable do
    it 'raises parser error' do
      expect { subject }.to raise_error(Rack::Analyzer::ParserError)
    end
  end

  context 'REPLACE' do
    let(:statement) { 'REPLACE INTO t1 (a) VALUES (1)' }

    it_behaves_like :not_parseable
  end
end
