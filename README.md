# RackDevInsight

RackDevInsight is a rack middleware for recording and analyzing database queries and HTTP request/response data.
A Chrome extension is needed to display the data in Devtools panel.
It is intended for development use only.

## Features

- Record database queries and aggregate them by:
  - CRUD operation
  - Normalized SQL
- Record HTTP request/response

## Supported libraries

#### Database clients:

- MySQL (i.e. [mysql2](https://github.com/brianmario/mysql2) gem)
- PostgreSQL (i.e. [pg](https://github.com/ged/ruby-pg) gem)
- SQLite3 (i.e. [sqlite3](https://github.com/sparklemotion/sqlite3-ruby) gem)

#### HTTP clients:

- [net-http](https://github.com/ruby/net-http) gem

## Status

[![Gem Version](https://badge.fury.io/rb/rack-dev_insight.svg)](https://badge.fury.io/rb/rack-dev_insight)
[![CI](https://github.com/takaebato/rack-dev_insight/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/takaebato/rack-dev_insight/actions/workflows/main.yml)

## Installation

### 1. Install gem

Add the following lines to your application's Gemfile:

```rb
group :development do
  gem 'rack-dev_insight'
end
```

Note that the following gems need to be listed before `rack-dev_insight` in the Gemfile if they are used in the application, letting `rack-dev_insight` patch them when loaded.

- [mysql2](https://github.com/brianmario/mysql2)
- [pg](https://github.com/ged/ruby-pg)
- [sqlite3](https://github.com/sparklemotion/sqlite3-ruby)

### 2. Setup middleware

#### Rails

No additional steps are required.
Middleware is automatically inserted by railtie.

#### Other Rack apps

Need to insert middleware manually.

For example, when using [Hanami](https://github.com/hanami/hanami):

```rb
# config.ru
require 'rack/dev_insight'

use Rack::DevInsight
```

### 3. Install Chrome extension

Install the extension from [Chrome Web Store](https://chrome.google.com/webstore/detail/rack-dev_insight/).

### Installation options

#### Enable SQL events subscription of `ActiveSupport::Notifications`

If you use `ActiveSupport::Notifications`, and want to avoid patching SQL client gems, you can enable SQL events subscription of `ActiveSupport::Notifications` by changing the Gemfile as follows:

```rb
group :development do
  gem 'rack-dev_insight', require: ['rack/dev_insight/enable_sql_subscription', 'rack/dev_insight']
end
```

In this setup, SQL patches are automatically disabled.

For Rails applications, the default subscribed events are `sql.active_record`, `sql.rom`, `sql.sequel`, and `sql.data_mapper`.
For other rack applications, or to subscribe to additional events, use `Rack::DevInsight::SqlNotifications.subscribe('new_sql_event_name')`.

<b>Notable limitation:</b> Only one SQL dialect is supported at a time, determined by the client library listed in the Gemfile. If multiple dialects are present, it defaults to mysql2, pg, then sqlite3 in order.
To use multiple dialects, SQL patching is the only option.

#### Disable patching of net-http

If you want to disable patching of `net-http`, you can change the Gemfile as follows:

```rb
group :development do
  gem 'rack-dev_insight', require: ['rack/dev_insight/disable_net_http_patch', 'rack/dev_insight']
end
```

## Usage

1. After installing the gem and extension, open the devtools and navigate to the 'RackDevInsight' tab.
2. Initiate a request in your application from the browser.
3. The HTTP request/response details and database queries executed during the request will be displayed in the panel.

## Configuration

| Name                         | Description                                                                                                                                                                                                                                                                    | Type          | Default                |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|------------------------|
| storage_type                 | Storage option. :memory or :file are available.                                                                                                                                                                                                                                | Symbol        | :memory                |
| memory_store_size            | Byte size of memory allocated for storing results. When memory usage exceeds this limit, the oldest result is deleted.                                                                                                                                                         | Integer       | 32 * 1024 * 1024       |
| file_store_pool_size         | Number of files of result to preserve. When the number of files exceeds this value, the oldest file is deleted.                                                                                                                                                                | Integer       | 100                    |
| file_store_dir_path          | Path to the directory for storing result files.                                                                                                                                                                                                                                | String        | 'tmp/rack-dev_insight' |          
| backtrace_depth              | Depth of the backtrace to record.                                                                                                                                                                                                                                              | Integer       | 5                      |              
| backtrace_exclusion_patterns | Exclusion patterns for paths when recording backtraces. If there's a match, the recording of the line is skipped.                                                                                                                                                              | Array<Regexp> | [/gems/]               | 
| prepared_statement_limit     | The maximum number of prepared statement objects stored in memory per database connection. It is recommended to set the value equal to (or higher than) the corresponding setting in your application. The default value is 1000, consistent with the default in ActiveRecord. | Integer       | 1000                   | 
| skip_cached_sql              | (Only when `ActiveSupport::Notifications` is used) whether to skip recording SQL that are cached.                                                                                                                                                                              | Boolean       | true                   | 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rack_dev_insight. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rack_dev_insight/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RackDevInsight project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rack_dev_insight/blob/master/CODE_OF_CONDUCT.md).
