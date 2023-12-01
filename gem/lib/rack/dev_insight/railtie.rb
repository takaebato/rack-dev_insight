# frozen_string_literal: true

require_relative './sql_dialects'
require_relative './sql_notifications'

module Rack
  class DevInsight
    class Railtie < ::Rails::Railtie
      initializer 'rack_dev_insight.middlewares' do |app|
        app.middleware.use(Rack::DevInsight)
      end
      initializer 'rack_dev_insight.subscribe_events' do
        if defined?(ENABLE_SQL_SUBSCRIPTION)
          DevInsight.config.detected_dialect = SqlDialects.detect_dialect
          SqlNotifications.subscribe_events
        end
      end
    end
  end
end
