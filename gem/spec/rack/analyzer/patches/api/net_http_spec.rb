require 'spec_helper'
require 'net/http'

RSpec.describe 'Patch net/http' do
  before do
    Rack::Analyzer::Context.create_current(SecureRandom.uuid)
  end

  it 'patches net/http' do
    expect(defined?(Net::HTTP::RackAnalyzer)).to eq(nil)
    load 'rack/analyzer/patches/api/net_http.rb'
    expect(Net::HTTP.ancestors.include?(Net::HTTP::RackAnalyzer)).to eq(true)
    uri = URI('http://localhost:8080/get')
    response = Net::HTTP.get_response(uri)
    expect(response).to be_kind_of(Net::HTTPResponse)
    expect(Rack::Analyzer::Context.current.result.attributes[:apis].size).to eq(1)
  end
end
