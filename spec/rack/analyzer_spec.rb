# frozen_string_literal: true

require 'rack/test'
require 'rack'

RSpec.describe Rack::Analyzer do
  include Rack::Test::Methods

  it "has a version number" do
    expect(Rack::Analyzer::VERSION).not_to be nil
  end
end
