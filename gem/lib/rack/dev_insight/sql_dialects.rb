# frozen_string_literal: true

module Rack
  class DevInsight
    module SqlDialects
      MYSQL = 'mysql'
      POSTGRESQL = 'postgresql'
      SQLITE = 'sqlite'
      DIALECTS = [MYSQL, POSTGRESQL, SQLITE].freeze

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

        def validate!(dialect, error_klass)
          return if DIALECTS.include?(dialect)

          raise error_klass, "Unsupported SQL dialect: #{dialect}. Supported dialects are: #{DIALECTS.join(', ')}"
        end
      end
    end
  end
end
