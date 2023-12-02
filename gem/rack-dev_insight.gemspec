# frozen_string_literal: true

require_relative 'lib/rack/dev_insight/version'

Gem::Specification.new do |spec|
  spec.name = 'rack-dev_insight'
  spec.version = Rack::DevInsight::VERSION
  spec.authors = ['Takahiro Ebato']
  spec.email = ['takahiro.ebato@gmail.com']
  spec.summary = 'A rack middleware for analyzing database queries and HTTP request/response.'
  spec.description = 'A rack middleware for analyzing database queries and HTTP request/response data. Chrome extension is needed to see the analysis result.'
  spec.homepage = 'https://github.com/takaebato/rack-dev_insight'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.2'
  spec.metadata = {
    'source_code_uri' => 'https://github.com/takaebato/rack-dev_insight',
    'changelog_uri' => 'https://github.com/takaebato/rack-dev_insight/blob/master/CHANGELOG.md',
    'rubygems_mfa_required' => 'true'
  }
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.require_paths = ['lib']
  spec.extensions = ['ext/rack_dev_insight/Cargo.toml']

  spec.add_dependency 'rack'
end
