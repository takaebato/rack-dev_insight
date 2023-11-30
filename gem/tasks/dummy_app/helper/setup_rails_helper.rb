# frozen_string_literal: true

module SetupRailsHelper
  def stop_docker
    puts '== Stop docker =='
    system('docker compose stop dummy-app-rails')
  end

  def build_image(version)
    puts '== Build image =='
    version ||= '3.0.2'
    system("RUBY_VERSION=#{version} docker compose build dummy-app-rails")
  end

  def create_rails_app_if_not_exists(version)
    version ||= '7.0'
    if Dir.exist?('tmp/dummy_app/rails') && !Dir.empty?('tmp/dummy_app/rails')
      puts '== Rails application already exists. Skip creating rails app. =='
      return
    end

    puts "== Create rails app with version #{version} =="
    system(<<~COMMAND)
      docker compose run -it --rm dummy-app-rails /bin/bash -c '\
      gem install rails -v #{version} && \
      rails new . --minimal --skip-bundle;'
    COMMAND
  end

  def set_database_config(database)
    database ||= 'sqlite'
    unless %w[sqlite mysql pg].include?(database)
      raise ArgumentError, "database must be one of 'sqlite', 'mysql', or 'pg'"
    end

    puts "== Set database config to #{database} =="
    system("cp -f tasks/dummy_app/template_files/database-#{database}.yml tmp/dummy_app/rails/config/database.yml")
  end

  def add_gems
    puts '== Add gems =='
    system(<<~COMMAND)
      docker compose run -it --rm dummy-app-rails /bin/bash -c '\
      bundle install && \
      (bundle show mysql2 || bundle add mysql2); \
      (bundle show pg || bundle add pg); \
      (bundle show net-http || bundle add net-http); \
      (bundle show rack-dev_insight || bundle add rack-dev_insight --path /gem);'
    COMMAND
  end

  def compile_gem
    puts '== Compile gem =='
    system(<<~COMMAND)
      docker compose run -it --rm dummy-app-rails /bin/bash -c '\
      cd /gem && \
      bundle install && \
      bundle exec rake compile;'
    COMMAND
  end

  def up_docker
    puts '== Up docker =='
    system('docker compose up -d dummy-app-rails')
  end

  def generate_scaffold
    puts '== Generate scaffold =='
    system(<<~COMMAND)
      docker compose exec dummy-app-rails /bin/bash -c '\
      bundle install && \
      bundle exec rails generate scaffold User name:string;'
    COMMAND
  end

  def migrate_reset
    puts '== Migrate reset =='
    system(<<~COMMAND)
      docker compose exec dummy-app-rails /bin/bash -c '\
      bundle exec rails db:migrate:reset;'
    COMMAND
  end

  def restart_docker
    puts '== Restart docker =='
    system('docker compose restart dummy-app-rails')
  end
end
