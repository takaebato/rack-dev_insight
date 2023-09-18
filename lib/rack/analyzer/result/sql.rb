# Frozen_string_literal: true

require_relative '../rack_analyzer'
require_relative '../ext/extractor'
require_relative '../ext/normalizer'

module Rack
  class Analyzer
    class Result
      class Sql
        class Crud
          def initialize
            @data = {}
          end

          def add(dialect_name, statement, duration, query_id)
            crud_tables = begin
                            Extractor::CrudTables.extract(dialect_name, statement)
                          rescue ExternalError => error
                            add_error(statement)
                            return
                          end

            crud_tables.each do |type, tables|
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

          def add(dialect_name, statement, duration, cached, query_id)
            normalized_statement = Ext::Normalizer.normalize(dialect_name, statement)

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

          def add(name, statement, backtrace, duration, cached)
            @data << {
              id: @id += 1,
              name: name,
              statement: statement,
              backtrace: backtrace,
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

        def add(name, statement, backtrace, duration, cached)
          @queries.add(name, statement, backtrace, duration, cached)
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
