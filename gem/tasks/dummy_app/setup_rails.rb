# frozen_string_literal: true

require_relative 'helper/setup_rails_helper'

namespace :dummy_app do
  # ex) bundle exec rake 'dummy_app:setup_rails[7.0,mysql]'
  desc 'Setup dummy application of rails to tmp/dummy_app/rails'
  task :setup_rails, %w[version database] do |_task, args|
    include SetupRailsHelper

    stop_docker
    create_rails_app(args[:version])
    set_database_config(args[:database])
    up_docker
    add_gems
    generate_scaffold
    restart_docker
  end
end
