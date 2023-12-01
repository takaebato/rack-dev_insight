# frozen_string_literal: true

module Rack
  class DevInsight
    class SqlNotifications
      DEFAULT_EVENT_NAMES = %w[sql.active_record sql.rom sql.sequel sql.data_mapper].freeze

      class << self
        def subscribe_events(event_names = DEFAULT_EVENT_NAMES)
          event_names.each { |event_name| subscribe(event_name) }
        end

        # @param [String] event_name
        def subscribe(event_name)
          ActiveSupport::Notifications.subscribe(event_name, &new)
        end
      end

      def to_proc
        method(:call).to_proc
      end

      def call(*args)
        _name, started, finished, _unique_id, data = args
        SqlRecorder.new.record_from_event(
          started: started,
          finished: finished,
          statement: data[:sql],
          binds: data[:type_casted_binds].try(:call) || data[:type_casted_binds],
          cached: data[:cached],
        )
      end
    end
  end
end
