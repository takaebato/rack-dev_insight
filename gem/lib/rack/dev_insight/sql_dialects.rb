# frozen_string_literal: true

module Rack
  class DevInsight
    module SqlDialects
      MYSQL = 'mysql'
      POSTGRESQL = 'postgresql'
      SQLITE = 'sqlite'

      class << self
        def detect_dialect
          if defined?(Mysql2)
            MYSQL
          elsif defined?(PG)
            POSTGRESQL
          elsif defined?(SQLite3)
            SQLITE
          end
        end
      end
    end
  end
end
