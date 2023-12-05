# frozen_string_literal: true

require 'rspec'
require 'rack'
require 'rack/test'
require 'committee'
require 'rspec-parameterized'
require 'dotenv'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
  # Patches tests cannot be profiled correctly because patch files are loaded multiple times in spec.
  add_group 'Patches', 'rack/dev_insight/patches'
end

require 'rack/dev_insight'
require 'db_helper'

# Load `.env.test.local` or `.env.test.docker`
Dotenv.load('.env.test.docker')

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
