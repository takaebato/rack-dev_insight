# frozen_string_literal: true

RSpec.describe Rack::Analyzer do
  it "has a version number" do
    expect(Rack::Analyzer::VERSION).not_to be nil
  end

  specify "normalizer works" do
    expect(Normalizer.normalize("SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = 'tmp'"))
      .to eq("SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = ?")
  end
end
