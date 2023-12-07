# Rack::DevInsight

Rack::DevInsight is a rack middleware for recording and analyzing SQL queries and HTTP request / response data.
A Chrome extension is needed to display the recorded data in Devtools panel.  
It is intended for <b>development use only</b>.

## Features

### Gem

- Record SQL queries and aggregate them by CRUD operation and Normalized statement
  - Supports MySQL, PostgreSQL, and SQLite3
- Record HTTP request / response
  - Supports requests using [net-http](https://github.com/ruby/net-http) gem

### Chrome extension

- Display recorded data in Devtools panel.
  - SQL queries
    - Queries grouped by CRUD operation, with total query count and duration
    - Queries grouped by normalized statement, with total query count and duration
    - All queries, with duration and backtrace
  - HTTP request / response
    - Request headers
    - Request body
    - Response headers
    - Response body
    - Duration
    - Backtrace

## Status

[![Gem Version](https://badge.fury.io/rb/rack-dev_insight.svg)](https://badge.fury.io/rb/rack-dev_insight)
[![CI](https://github.com/takaebato/rack-dev_insight/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/takaebato/rack-dev_insight/actions/workflows/main.yml)

## Installation

### For Rails applications

Add the following lines to your application's Gemfile:

```ruby
group :development do
  gem 'rack-dev_insight'
end
```

That's it.

By railtie, middleware is automatically inserted, and SQL queries are recorded through `ActiveSupport::Notifications`.  
The default subscriptions include `sql.active_record`, `sql.rom`, and `sql.sequel`.
More event subscriptions can be added by:

```ruby
Rack::DevInsight::SqlNotifications.subscribe('new_sql_event_name')
```

#### Limitation

Only one SQL dialect is supported at a time, determined by the database client gems (i.e. [mysql2](https://github.com/brianmario/mysql2), [pg](https://github.com/ged/ruby-pg) or [sqlite3](https://github.com/sparklemotion/sqlite3-ruby)) listed in the Gemfile.
If multiple clients are present, it defaults to mysql2, pg, then sqlite3 in order.
To use multiple dialects simultaneously, [SQL patch option](https://github.com/takaebato/rack-dev_insight#1-enable-sql-patch-option) can be used.
When this option is enabled, railtie does not subscribe sql events to prevent duplicate recording.

### For other Rack applications

You have two options to record SQL queries.

#### 1. Enable SQL patch option

Enabling this option will patch database client gems. Currently, [mysql2](https://github.com/brianmario/mysql2) and [pg](https://github.com/ged/ruby-pg) gems are supported.

Add the following lines to your application's Gemfile:

```ruby
group :development do
  gem 'rack-dev_insight', require: ['rack/dev_insight/enable_sql_patch', 'rack/dev_insight']
end
```

Make sure to list the mysql2 and pg gems before `rack-dev_insight` in the Gemfile, letting `rack-dev_insight` patch them when loaded.

#### 2. Manually call record method provided by `Rack::DevInsight::SqlRecorder`

First, add the following lines to your application's Gemfile:

```ruby
group :development do
  gem 'rack-dev_insight'
end
````

If you can execute hooks following SQL executions, such as via the notification system of [dry-monitor](https://github.com/dry-rb/dry-monitor), you can use the following method to record SQL queries.

```ruby
Rack::DevInsight::SqlRecorder.record(dialect: 'mysql', statement: 'SELECT * FROM users WHERE id = ?', binds: [1], duration: 5.0)
```

Keyword arguments are described below:

| name      | description                                             | type   | required | 
|-----------|---------------------------------------------------------|--------|----------|
| dialect   | SQL dialect. 'mysql', 'pg', or 'sqlite3' are available. | String | required |
| statement | SQL statement.                                          | String | required |
| binds     | Parameters bound to SQL statement.                      | Array  | optional |
| duration  | SQL execution time.                                     | Float  | required |

#### Insert middleware manually

Need to insert the middleware into your application's middleware stack.

For example, when using [Hanami](https://github.com/hanami/hanami):

```rb
# config.ru
require 'rack/dev_insight'

use Rack::DevInsight
```

### Installation options

#### Disable net-http patch

If you want to disable `net-http` patch, you can change the Gemfile as follows:

```rb
group :development do
  gem 'rack-dev_insight', require: ['rack/dev_insight/disable_net_http_patch', 'rack/dev_insight']
end
```

### Install Chrome extension

Install the extension from [Chrome Web Store](https://chrome.google.com/webstore/detail/rack-dev_insight/).

## Usage

1. After installing the gem and extension, open the devtools and navigate to the 'RackDevInsight' tab.
2. Initiate a request in your application from the browser.
3. The HTTP request / response details and SQL queries executed during the request will be displayed in the panel.

## Configuration

You can set configuration options by `Rack::DevInsight.configure`. For example:

```ruby
Rack::DevInsight.configure do |config|
  config.storage_type = :file
  config.file_store_pool_size = 1000
  config.backtrace_depth = 10
end
```

Available options are described below:

| Name                         | Description                                                                                                                                                                                                                                                                    | Type            | Default                |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|------------------------|
| storage_type                 | Storage option. :memory or :file are available.                                                                                                                                                                                                                                | Symbol          | :memory                |
| memory_store_size            | Byte size of memory allocated for storing results. When memory usage exceeds this limit, the oldest result is deleted.                                                                                                                                                         | Integer         | 32 * 1024 * 1024       |
| file_store_pool_size         | Number of files of result to preserve. When the number of files exceeds this value, the oldest file is deleted.                                                                                                                                                                | Integer         | 100                    |
| file_store_dir_path          | Path to the directory for storing result files.                                                                                                                                                                                                                                | String          | 'tmp/rack-dev_insight' |          
| skip_paths                   | Skip recording of requests whose path matches the given patterns.                                                                                                                                                                                                              | Array\<Regexp\> | `[]`                   |
| backtrace_depth              | Depth of the backtrace to record.                                                                                                                                                                                                                                              | Integer         | 5                      |              
| backtrace_exclusion_patterns | Exclusion patterns for paths when recording backtraces. If there's a match, the recording of the line is skipped.                                                                                                                                                              | Array\<Regexp\> | `[%r{/gems/}]`         | 
| prepared_statement_limit     | The maximum number of prepared statement objects stored in memory per database connection. It is recommended to set the value equal to (or higher than) the corresponding setting in your application. The default value is 1000, consistent with the default in ActiveRecord. | Integer         | 1000                   | 
| skip_cached_sql              | Skip the recording of cached SQL queries. This option has effect only when used with `ActiveSupport::Notifications`.                                                                                                                                                           | Boolean         | true                   | 

## Contributing

See [CONTRIBUTING.md](https://github.com/takaebato/rack-dev_insight/blob/master/CONTRIBUTING.md)

## Thanks

Special thanks to the [rails_panel](https://github.com/dejan/rails_panel) and [rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler) teams for their invaluable insights and innovations that greatly influenced this project.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `rack-dev_insight` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rack_dev_insight/blob/master/CODE_OF_CONDUCT.md).
