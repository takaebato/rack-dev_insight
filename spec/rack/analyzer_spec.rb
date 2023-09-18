# frozen_string_literal: true

require 'rack/test'
require 'rack'

RSpec.describe Rack::Analyzer do
  include Rack::Test::Methods

  it "has a version number" do
    expect(Rack::Analyzer::VERSION).not_to be nil
  end

  specify "normalizer works" do
    expect(Rack::Analyzer::Normalizer.normalize("SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = 'tmp'"))
      .to eq("SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = ?")
  end

  specify "extractor works" do
    res = Rack::Analyzer::Extractor::CrudTables.extract('mysql', "SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = 'tmp'")
    expect(res).to eq({
                        'create_tables' => [],
                        'read_tables' => ["table_a", "table_b"],
                        'update_tables' => [],
                        'delete_tables' => []
                      })
  end

  def app
    Rack::Builder.new do
      use Rack::Analyzer
      run lambda { |_env| [200, {}, ['Hello World']] }
    end.to_app
  end

  it 'works' do
    get "/app"
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'Hello World'
    id = last_response.headers['x-rackanalyzer-id']
    get "/rack_analyzer_results/#{id}"
    expect(last_response).to be_ok
    expect(last_response.body).to eq Rack::Analyzer::Result.new(id).to_json
  end
end
