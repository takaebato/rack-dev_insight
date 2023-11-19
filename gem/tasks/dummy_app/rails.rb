# frozen_string_literal: true

require_relative 'helper/setup_rails_helper'

namespace :dummy_app do
  namespace :rails do
    # ex) bundle exec rake dummy_app:rails:setup'[3.1.3,7.0,sqlite]'
    desc 'Create a rails application with rack analyzer gem on docker and sync it with tmp/dummy_app/rails on host'
    task :setup, %w[ruby_version rails_version database] do |_task, args|
      include SetupRailsHelper

      stop_docker
      build_image(args[:ruby_version])
      create_rails_app(args[:rails_version])
      set_database_config(args[:database])
      up_docker
      add_gems
      generate_scaffold
      migrate_reset
      restart_docker
    end

    # ex) bundle exec rake dummy_app:rails:switch_database'[mysql]'
    desc 'Replace database.yml and reset database'
    task :switch_database, %w[database] do |_task, args|
      include SetupRailsHelper

      stop_docker
      set_database_config(args[:database])
      up_docker
      migrate_reset
      restart_docker
    end

    # ex) bundle exec rake dummy_app:rails:remove
    desc 'Remove dummy application of rails of tmp/dummy_app/rails'
    task :remove do
      system 'rm -rf tmp/dummy_app/rails'
    end
  end
end
