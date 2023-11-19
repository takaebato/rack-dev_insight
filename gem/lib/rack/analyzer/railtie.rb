# frozen_string_literal: true

module Rack
  class Analyzer
    class Railtie < ::Rails::Railtie
      initializer 'rack_analyzer.middlewares' do |app|
        app.middleware.use(Rack::Analyzer)
      end
    end
  end
end
