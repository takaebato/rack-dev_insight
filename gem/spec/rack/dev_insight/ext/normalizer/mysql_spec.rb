# frozen_string_literal: true

require 'spec_helper'
require 'rack/dev_insight/ext/normalizer/normalizer_helper'

RSpec.describe Rack::DevInsight::Normalizer do
  describe '.normalize' do
    include NormalizerHelper

    subject { described_class.normalize(Rack::DevInsight::SqlDialects::MYSQL, statement) }

    context 'SELECT' do
      context 'PARTITION' do
        let(:statement) { 'SELECT a FROM t1 PARTITION (p0)' }
        # Not desirable. Table name and partition name are not separated.
        let(:normalized) { ['SELECT a FROM t1PARTITION (p0)'] }
        it_behaves_like :normalize
      end
    end
  end
end
