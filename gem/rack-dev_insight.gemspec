# frozen_string_literal: true

require_relative 'lib/rack/dev_insight/version'

Gem::Specification.new do |spec|
  spec.name = 'rack-dev_insight'
  spec.version = Rack::DevInsight::VERSION
  spec.authors = ['Takahiro Ebato']
  spec.email = ['takahiro.ebato@gmail.com']
  spec.summary = 'A rack middleware for analyzing SQL queries and HTTP request / response data.'
  spec.description = 'A rack middleware for analyzing SQL queries and HTTP request / response data. Chrome extension is needed to display the analysis result.'
  spec.homepage = 'https://github.com/takaebato/rack-dev_insight'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.2'
  # https://github.com/rubygems/rubygems/pull/5852#issuecomment-1231118509
  spec.required_rubygems_version = '>= 3.3.22'
  spec.metadata = {
    'source_code_uri' => 'https://github.com/takaebato/rack-dev_insight',
    'changelog_uri' => 'https://github.com/takaebato/rack-dev_insight/blob/master/CHANGELOG.md',
    'rubygems_mfa_required' => 'true'
  }
  spec.files = Dir['lib/**/*']
  spec.files.reject! { |f| File.directory?(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_dependency 'rb_sys', '~> 0.9.85'
  spec.add_dependency 'sql_insight', '~> 0.1.0'
end
