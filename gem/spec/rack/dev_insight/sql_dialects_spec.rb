# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::DevInsight::SqlDialects do
  describe '.detect_dialect' do
    it 'detects mysql' do
      expect(described_class.detect_dialect).to eq('mysql') # mysql is loaded in spec_helper.rb
    end
  end

  describe '.validate!' do
    context 'when dialect is supported' do
      it 'is valid' do
        expect(described_class.validate!('mysql', ArgumentError)).to be_nil
      end
    end

    context 'when dialect is not supported' do
      it 'raises error' do
        expect { described_class.validate!('hoge', ArgumentError) }.to raise_error(ArgumentError)
      end
    end
  end
end
