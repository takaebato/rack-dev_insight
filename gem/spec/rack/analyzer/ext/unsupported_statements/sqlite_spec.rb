# frozen_string_literal: true
require 'spec_helper'
require 'rack/analyzer/ext/extractor/extractor_helper'

RSpec.describe 'List unsupported statements' do
  include ExtractorHelper

  # use CrudTables extractor to parse statements
  subject { Rack::Analyzer::Extractor::CrudTables.extract(Rack::Analyzer::SqlDialects::SQLITE, statement) }

  shared_examples :not_parseable do
    it 'raises parser error' do
      expect { subject }.to raise_error(Rack::Analyzer::ParserError)
    end
  end
end
