# frozen_string_literal: true

require 'spec_helper'
require 'rack/dev_insight/ext/extractor/extractor_helper'

RSpec.describe 'List unsupported statements' do
  include ExtractorHelper

  # use CrudTables extractor to parse statements
  subject { Rack::DevInsight::Extractor::CrudTables.extract(Rack::DevInsight::SqlDialects::SQLITE, statement) }

  shared_examples :not_parseable do
    it 'raises parser error' do
      expect { subject }.to raise_error(SqlInsight::ParserError)
    end
  end
end
