# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::DevInsight::FileStore do
  let(:file_store) { described_class.new }

  before do
    mock_result = Struct.new(:id, :value)
    stub_const('Result', mock_result)
  end

  it 'can write and read data' do
    result = Result.new(1, 'hoge')
    file_store.write(result)
    res = file_store.read(result.id)
    expect(res.value).to eq('hoge')
  end

  context 'when reaching the file pool size limit' do
    before { Rack::DevInsight.configure { |config| config.file_store_pool_size = 2 } }

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
