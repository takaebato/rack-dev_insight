# frozen_string_literal: true

module Rack
  class DevInsight
    class Railtie < ::Rails::Railtie
      initializer 'rack_dev_insight.middlewares' do |app|
        app.middleware.use(Rack::DevInsight)
      end
    end
  end
end
