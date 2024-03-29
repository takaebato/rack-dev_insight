# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Patch net/http' do
  before { Rack::DevInsight::Context.create_current(SecureRandom.uuid) }

  it 'patches net/http' do
    expect(Net::HTTP.ancestors.include?(Net::HTTP::RackDevInsight)).to eq(true)
    uri = URI("http://#{ENV.fetch('MOCK_HTTP_SERVER_HOST', nil)}:#{ENV.fetch('MOCK_HTTP_SERVER_PORT', nil)}/get")
    response = Net::HTTP.get_response(uri)
    expect(response).to be_kind_of(Net::HTTPResponse)
    Net::HTTP.start(uri.host, uri.port) { |http| http.get('/get') }
    expect(Rack::DevInsight::Context.current.result.attributes[:apis].size).to eq(2)
    expect(Rack::DevInsight::Context.current.result.attributes[:apis][1][:url].to_s).to eq(
      "#{ENV.fetch('MOCK_HTTP_SERVER_HOST', nil)}:#{ENV.fetch('MOCK_HTTP_SERVER_PORT', nil)}/get",
    )
  end
end
