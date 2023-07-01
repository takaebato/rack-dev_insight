# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe Rack::Analyzer::MemoryStore do
  let(:target) { described_class.new }

  it 'can write and read data' do
    id = SecureRandom.uuid
    target.write({ id: id, sample: 'sample_value' })
    res = target.read(id)
    expect(res[:id]).to eq(id)
    expect(res[:sample]).to eq('sample_value')
  end
end
