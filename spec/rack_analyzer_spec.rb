# frozen_string_literal: true

RSpec.describe Rack::Analyzer do
  it "has a version number" do
    expect(Rack::Analyzer::VERSION).not_to be nil
  end

  specify "normalizer works" do
    expect(Normalizer.normalize("SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = 'tmp'"))
      .to eq("SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = ?")
  end

  specify "extractor works" do
    res = Extractor.extract_crud_tables("SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = 'tmp'")
    expect(res).to eq({
                        'create_tables' => [],
                        'read_tables' => ["table_a", "table_b"],
                        'update_tables' => [],
                        'delete_tables' => []
                      })
  end
end
