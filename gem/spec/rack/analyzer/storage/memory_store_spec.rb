# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::Analyzer::MemoryStore do
  Result = Struct.new(:id, :value)

  let(:memory_store) { described_class.new }

  it 'can write and read data' do
    result = Result.new(1, 'hoge')
    memory_store.write(result)
    res = memory_store.read(result.id)
    expect(res.value).to eq('hoge')
  end

  context 'when reaching the memory limit' do
    before do
      Rack::Analyzer.configure do |config|
        config.memory_store_size = 60
      end
    end

    it 'reaps excess memory' do
      memory_store.write(Result.new(1, 'hoge'))
      memory_store.write(Result.new(2, 'hoge'))
      memory_store.write(Result.new(3, 'hoge'))
      expect(memory_store.read(1)).to be_nil
      expect(memory_store.read(2)).not_to be_nil
      expect(memory_store.read(3)).not_to be_nil
    end
  end
end
