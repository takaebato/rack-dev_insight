# frozen_string_literal: true

module Rack
  class DevInsight
    module Extractor
      class CrudTables
        class << self
          def extract(dialect_name, statement)
            crud_tables = SqlInsight.extract_crud_tables(dialect_name, statement)
            results = { 'CREATE' => [], 'READ' => [], 'UPDATE' => [], 'DELETE' => [] }

            crud_tables.each do |crud_table|
              results['CREATE'].concat(crud_table.create_tables.map(&:name).map(&:to_s))
              results['READ'].concat(crud_table.read_tables.map(&:name).map(&:to_s))
              results['UPDATE'].concat(crud_table.update_tables.map(&:name).map(&:to_s))
              results['DELETE'].concat(crud_table.delete_tables.map(&:name).map(&:to_s))
            end

            results
          end
        end
      end
    end
  end
end
