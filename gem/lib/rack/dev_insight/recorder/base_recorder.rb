# frozen_string_literal: true

module Rack
  class DevInsight
    class BaseRecorder
      private

      def format_binds(binds)
        if binds.nil? || binds.empty? || (binds.is_a?(Array) && binds.all? { _1.respond_to?(:empty?) && _1.empty? })
          ''
        else
          binds.to_s
        end
      end

      def get_backtrace
        Kernel
          .caller
          .reject { |line| DevInsight.config.backtrace_exclusion_patterns.any? { |regex| line =~ regex } }
          .first(DevInsight.config.backtrace_depth)
          .map do |line|
            if (match = line.match(/(?<path>.*):(?<line>\d+)/))
              Result.build_backtrace_item(line, match[:path], match[:line].to_i)
            end
          end
          .compact
      end
    end
  end
end
