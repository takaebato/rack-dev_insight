# frozen_string_literal: true

require 'spec_helper'
require 'net/http'

RSpec.describe 'Patch net/http' do
  before { Rack::DevInsight::Context.create_current(SecureRandom.uuid) }

  it 'patches net/http' do
    load 'rack/dev_insight/patches/api/net_http.rb'
    expect(Net::HTTP.ancestors.include?(Net::HTTP::RackDevInsight)).to eq(true)
    uri = URI("http://#{ENV.fetch('MOCK_HTTP_SERVER_HOST', nil)}:#{ENV.fetch('MOCK_HTTP_SERVER_PORT', nil)}/get")
    response = Net::HTTP.get_response(uri)
    expect(response).to be_kind_of(Net::HTTPResponse)
    expect(Rack::DevInsight::Context.current.result.attributes[:apis].size).to eq(1)
  end
end
