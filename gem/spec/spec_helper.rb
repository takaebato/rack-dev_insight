# frozen_string_literal: true

require 'rspec'
require 'rack'
require 'rack/test'
require 'committee'
require 'rspec-parameterized'
require 'dotenv'
require 'simplecov'
SimpleCov.start { add_filter '/spec' }

require 'mysql2'
require 'pg'
require 'net/http'
require 'rack/dev_insight/enable_sql_patch' # SQL patches are enabled by default in tests

require 'rack/dev_insight'
require 'db_helper'

# Load `.env.test.local` or `.env.test.docker`
Dotenv.load('.env.test.local')

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  include DbHelper
end
