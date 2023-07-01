# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe Rack::Analyzer::MemoryStore do
  let(:target) { described_class.new }

  it 'can write and read data' do
    id = SecureRandom.uuid
    target.write(Rack::Analyzer::Result.new(id))
    res = target.read(id)
    expect(res.to_h[:id]).to eq(id)
  end
end
