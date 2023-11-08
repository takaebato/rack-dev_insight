# frozen_string_literal: true

module Rack
  class Analyzer
    module Extractor
      class CrudTables
        class << self
          def extract(dialect_name, statement)
            crud_tables = _extract(dialect_name, statement)
            {
              'CREATE' => crud_tables._create_tables,
              'READ' => crud_tables._read_tables,
              'UPDATE' => crud_tables._update_tables,
              'DELETE' => crud_tables._delete_tables
            }
          end
        end
      end
    end
  end
end
