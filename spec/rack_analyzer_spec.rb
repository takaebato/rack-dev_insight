# frozen_string_literal: true

RSpec.describe Rack::Analyzer do
  it "has a version number" do
    expect(Rack::Analyzer::VERSION).not_to be nil
  end

  specify "magnus works" do
    expect(HelloRust.hello('tmp')).to eq('Hello from Rust, tmp!')
  end
end
