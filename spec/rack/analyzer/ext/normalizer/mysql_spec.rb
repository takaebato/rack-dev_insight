require 'spec_helper'
require 'rack/analyzer/ext/normalizer/normalizer_helper'

RSpec.describe Rack::Analyzer::Normalizer do
  describe '.normalize' do
    include NormalizerHelper

    subject { described_class.normalize(Rack::Analyzer::SqlDialects::MYSQL, statement) }

    context 'SELECT' do
      context 'PARTITION' do
        let(:statement) { 'SELECT a FROM t1 PARTITION (p0)' }
        let(:normalized) { 'SELECT a FROM t1PARTITION (p0)' } # Not desirable. Table name and partition name are not separated.

        it_behaves_like :normalize
      end
    end
  end
end
