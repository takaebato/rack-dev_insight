# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::Analyzer::FileStore do
  Result = Struct.new(:id, :value)

  let(:file_store) { described_class.new }

  it 'can write and read data' do
    result = Result.new(1, 'hoge')
    file_store.write(result)
    res = file_store.read(result.id)
    expect(res.value).to eq('hoge')
  end

  context 'when reaching the file pool size limit' do
    before do
      Rack::Analyzer.configure do |config|
        config.file_store_pool_size = 2
      end
    end

    it 'reaps excess files' do
      file_store.write(Result.new(1, 'hoge'))
      file_store.write(Result.new(2, 'hoge'))
      file_store.write(Result.new(3, 'hoge'))
      expect(file_store.read(1)).to be_nil
      expect(file_store.read(2)).not_to be_nil
      expect(file_store.read(3)).not_to be_nil
    end
  end
end
