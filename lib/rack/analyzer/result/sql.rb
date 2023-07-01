# Frozen_string_literal: true

module Rack
  class Analyzer
    class Result
      class Sql
        class Crud
          def initialize
            @data = {}
          end

          def add(statement, duration, query_id)
            crud_tables = Extractor.extract_crud_tables(statement)
            [
              ['C', crud_tables['create_tables']],
              ['R', crud_tables['read_tables']],
              ['U', crud_tables['update_tables']],
              ['D', crud_tables['delete_tables']]
            ].each do |type, tables|
              add_crud(type, tables, duration, query_id)
            end
          end

          def to_h
            @data
          end

          private

          def add_crud(type, tables, duration, query_id)
            tables.each do |table|
              key = generate_key(type, table)
              data = @data[key] ||= init_data(type, table)
              data[:count] += 1
              data[:duration] += duration
              data[:query_ids] << query_id
            end
          end

          def init_data(type, table)
            {
              type: type,
              table: table,
              count: 0,
              duration: 0,
              query_ids: []
            }
          end

          def generate_key(type, table)
            "#{type}_#{table.downcase}"
          end
        end

        class Normalized
          def initialize
            @data = {}
          end

          def add(statement, duration, cached, query_id)
            normalized_statement = Normalizer.normalize(statement)

            data = @data[normalized_statement] ||= init_data(normalized_statement)
            data[:count] += 1
            data[:duration] += duration
            data[:cached] += 1 if cached
            data[:query_ids] << query_id
          end

          def to_h
            @data
          end

          private

          def init_data(statement)
            {
              statement: statement,
              count: 0,
              duration: 0,
              cached: 0,
              query_ids: []
            }
          end
        end

        class Queries
          attr_reader :id

          def initialize
            @id = 0
            @data = []
          end

          def add(name, statement, stack_trace, duration, cached)
            @data << {
              id: @id += 1,
              name: name,
              statement: statement,
              stack_trace: stack_trace,
              duration: duration,
              cached: cached
            }
          end

          def to_h
            @data
          end
        end

        def initialize
          @crud = Crud.new
          @normalized = Normalized.new
          @queries = Queries.new
        end

        def add(name, statement, stack_trace, duration, cached)
          @queries.add(name, statement, stack_trace, duration, cached)
          @crud.add(statement, duration, @queries.id)
          @normalized.add(statement, duration, cached, @queries.id)
        end

        def to_h
          {
            crud: @crud.to_h,
            normalized: @normalized.to_h,
            queries: @queries.to_h
          }
        end
      end
    end
  end
end
