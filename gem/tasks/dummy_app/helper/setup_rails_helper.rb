# frozen_string_literal: true

module SetupRailsHelper
  def stop_docker
    system('docker compose stop dummy-app-rails')
  end

  def build_image(version)
    version ||= '3.1.3'
    system("RUBY_VERSION=#{version} docker compose build dummy-app-rails")
  end

  def create_rails_app(version)
    version ||= '7.0'
    system(<<~COMMAND)
      docker compose run -it --rm dummy-app-rails /bin/bash -c '\
      gem install rails -v #{version} && \
      rails new . --minimal;'
    COMMAND
  end

  def set_database_config(database)
    database ||= 'sqlite'
    unless %w[sqlite mysql pg].include?(database)
      raise ArgumentError, "database must be one of 'sqlite', 'mysql', or 'pg'"
    end

    system("cp -f tasks/dummy_app/template_files/database-#{database}.yml tmp/dummy_app/rails/config/database.yml")
  end

  def up_docker
    system('docker compose up -d dummy-app-rails')
  end

  def add_gems
    system(<<~COMMAND)
      docker compose exec dummy-app-rails /bin/bash -c '\
      (bundle show mysql2 || bundle add mysql2); \
      (bundle show pg || bundle add pg); \
      (bundle show net-http || bundle add net-http); \
      (bundle show rack-analyzer || bundle add rack-analyzer --path /gem);'
    COMMAND
  end

  def generate_scaffold
    system(<<~COMMAND)
      docker compose exec dummy-app-rails /bin/bash -c '\
      bundle install && \
      bundle exec rails generate scaffold User name:string;'
    COMMAND
  end

  def migrate_reset
    system(<<~COMMAND)
      docker compose exec dummy-app-rails /bin/bash -c '\
      bundle exec rails db:migrate:reset;'
    COMMAND
  end

  def restart_docker
    system('docker compose restart dummy-app-rails')
  end
end
