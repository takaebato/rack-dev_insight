# frozen_string_literal: true

require 'spec_helper'
require 'rack/dev_insight/ext/extractor/extractor_helper'

RSpec.describe 'List unsupported statements' do
  include ExtractorHelper

  # use CrudTables extractor to parse statements
  subject { Rack::DevInsight::Extractor::CrudTables.extract(Rack::DevInsight::SqlDialects::MYSQL, statement) }

  shared_examples :not_parseable do
    it 'raises parser error' do
      expect { subject }.to raise_error(Rack::DevInsight::ParserError)
    end
  end

  context 'REPLACE' do
    let(:statement) { 'REPLACE INTO t1 (a) VALUES (1)' }

    it_behaves_like :not_parseable
  end
end
