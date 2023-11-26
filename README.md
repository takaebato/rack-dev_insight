# RackDevInsight

RackDevInsight is a rack middleware designed for recording and analyzing HTTP request/response data and database queries.
A corresponding Chrome extension is required to display the recorded data in the Devtools panel.
This tool is specifically intended for use in development environments only.

## Features

- Record database queries and aggregate them by:
  - CRUD operation
  - Normalized SQL
- Record HTTP request/response

#### Supported databases

- MySQL (i.e. [mysql2](https://github.com/brianmario/mysql2) gem)
- PostgreSQL (i.e. [pg](https://github.com/ged/ruby-pg) gem)
- SQLite3 (i.e. [sqlite3](https://github.com/sparklemotion/sqlite3-ruby) gem)

#### Supported HTTP clients

- [net-http](https://github.com/ruby/net-http) gem

## Status

[![Gem Version](https://badge.fury.io/rb/rack-dev-insight.svg)](https://badge.fury.io/rb/rack-dev-insight)
[![CI](https://github.com/takaebato/rack-dev-insight/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/takaebato/rack-dev-insight/actions/workflows/main.yml)

## Installation

### Gem

Add this line to your application's Gemfile:

```rb
group :development do
  gem 'rack-dev-insight'
end
```

Note that the following gems need to be listed before `rack-dev-insight` in the Gemfile if they are used in the application, letting `rack-dev-insight` to patch them when loaded.

- [mysql2](https://github.com/brianmario/mysql2)
- [pg](https://github.com/ged/ruby-pg)
- [sqlite3](https://github.com/sparklemotion/sqlite3-ruby)

[net-http](https://github.com/ruby/net-http) is also patched to record HTTP requests. If you want to disable this feature, change the Gemfile as follows:

```rb
group :development do
  gem 'rack-dev-insight', require: ['rack/dev_insight/disable_net_http_patch', 'rack-dev-insight']
end
```

#### Rails

No additional steps are required. Rack middleware is automatically inserted by railtie.

#### Other Rack apps

Need to insert middleware manually.

For example, when using [Hanami](https://github.com/hanami/hanami):

```rb
# config.ru
require 'rack-dev-insight'

use Rack::DevInsight
```

when using [Sinatra](https://github.com/sinatra/sinatra):

```rb
# app.rb
require 'rack-dev-insight'

class MyApp < Sinatra::Base
  use Rack::DevInsight
end
```

### Chrome extension

Install the extension from [Chrome Web Store](https://chrome.google.com/webstore/detail/rack-dev-insight/).

## Usage

1. After installing the gem and extension, open the devtools and navigate to the 'RackDevInsight' tab.
2. Initiate a request in your application from the browser.
3. The HTTP request/response details and database queries executed during the request will be displayed in the panel.

## Configuration

| Name                         | Description                                                                                                                                                                                            | Type            | Default                |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|------------------------|
| storage_type                 | Storage option. :memory or :file are available.                                                                                                                                                        | Symbol          | :memory                |
| memory_store_size            | Byte size of memory allocated for storing results. When memory usage exceeds this limit, the oldest result is deleted.                                                                                 | Integer         | 32 * 1024 * 1024       |
| file_store_pool_size         | Number of files of result to preserve. When the number of files exceeds this value, the oldest file is deleted.                                                                                        | Integer         | 100                    |
| file_store_dir_path          | Path to the directory for storing result files.                                                                                                                                                        | String          | 'tmp/rack-dev-insight' |          
| skip_backtrace               | Flag to skip recording backtrace.                                                                                                                                                                      | Boolean         | false                  |
| backtrace_exclusion_patterns | Exclusion patterns for paths when recording backtraces. If there's a match, recording is skipped.                                                                                                      | Array of Regexp | [/gems/]               | 
| backtrace_depth              | Depth of the backtrace to record.                                                                                                                                                                      | Integer         | 5                      |              
| prepared_statement_limit     | Number of prepared statements to maintain in a database connection. Ideally, this value should be synchronized with the application settings. For example, in ActiveRecord, the default value is 1000. | Integer         | 1000                   | 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rack_dev_insight. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rack_dev_insight/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RackDevInsight project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rack_dev_insight/blob/master/CODE_OF_CONDUCT.md).
