# frozen_string_literal: true

module Rack
  class Analyzer
    module Extractor
      class CrudTables
        class << self
          def extract(dialect_name, statement)
            crud_tables = _extract(dialect_name, statement)
            {
              'create' => crud_tables._create_tables,
              'read' => crud_tables._read_tables,
              'update' => crud_tables._update_tables,
              'delete' => crud_tables._delete_tables
            }
          end
        end
      end
    end
  end
end
