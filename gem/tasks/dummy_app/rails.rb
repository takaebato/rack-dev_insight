# frozen_string_literal: true

require_relative 'helper/setup_rails_helper'

namespace :dummy_app do
  namespace :rails do
    # ex) bundle exec rake dummy_app:rails:setup'[3.0.2,7.0,sqlite]'
    desc 'Create a rails application with rack dev insight gem on docker and sync it with tmp/dummy_app/rails on host'
    task :setup, %w[ruby_version rails_version database] do |_task, args|
      include SetupRailsHelper

      database = args[:database] || 'sqlite'
      unless %w[sqlite mysql pg].include?(database)
        raise ArgumentError, "database must be one of 'sqlite', 'mysql', or 'pg'"
      end

      stop_docker
      build_image(args[:ruby_version])
      create_rails_app_if_not_exists(args[:rails_version])
      set_database_config(database)
      remove_and_add_gems(database)
      compile_gem
      up_docker
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
