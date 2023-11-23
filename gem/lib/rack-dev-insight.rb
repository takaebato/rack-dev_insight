# frozen_string_literal: true

require_relative 'rack/dev_insight/version'
require_relative 'rack/dev_insight/rack_dev_insight'
require_relative 'rack/dev_insight/storage/memory_store'
require_relative 'rack/dev_insight/storage/file_store'
require_relative 'rack/dev_insight/result'
require_relative 'rack/dev_insight/recorder'
require_relative 'rack/dev_insight/config'
require_relative 'rack/dev_insight/context'
require_relative 'rack/dev_insight/errors'
require_relative 'rack/dev_insight/sql_dialects'
require_relative 'rack/dev_insight/patches/sql/mysql2'
require_relative 'rack/dev_insight/patches/sql/pg'
require_relative 'rack/dev_insight/patches/sql/sqlite'
require_relative 'rack/dev_insight/patches/api/net_http'
require_relative 'rack/dev_insight'

require_relative 'rack/dev_insight/railtie' if defined?(Rails)
