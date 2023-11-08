require 'spec_helper'
require 'rack/analyzer/ext/normalizer/normalizer_helper'

RSpec.describe Rack::Analyzer::Normalizer do
  describe '.normalize' do
    include NormalizerHelper

    subject { described_class.normalize(Rack::Analyzer::SqlDialects::SQLITE, statement) }

    context 'REPLACE' do
      let(:statement) { 'REPLACE INTO t1 (a) VALUES (1)' }
      let(:normalized) { 'INSERT OR REPLACE INTO t1 (a) VALUES (?)' }

      it_behaves_like :normalize
    end
  end
end

