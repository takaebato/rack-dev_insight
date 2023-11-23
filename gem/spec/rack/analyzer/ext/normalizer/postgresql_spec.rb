# frozen_string_literal: true

require 'spec_helper'
require 'rack/analyzer/ext/normalizer/normalizer_helper'

RSpec.describe Rack::Analyzer::Normalizer do
  describe '.normalize' do
    include NormalizerHelper

    subject { described_class.normalize(Rack::Analyzer::SqlDialects::POSTGRESQL, statement) }

    describe 'INSERT ON CONFLICT' do
      let(:statement) { 'INSERT INTO t1 (a) VALUES (1) ON CONFLICT (a) DO NOTHING' }
      let(:normalized) { 'INSERT INTO t1 (a) VALUES (?)  ON CONFLICT(a) DO NOTHING' }

      it_behaves_like :normalize
    end
  end
end
