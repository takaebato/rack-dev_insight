# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rack::DevInsight::SqlRecorder do
  before { Rack::DevInsight::Context.create_current(SecureRandom.uuid) }

  describe '.record' do
    it do
      described_class.record(
        dialect: 'mysql',
        statement: 'SELECT * FROM users WHERE id = ?',
        binds: [1],
        duration: 10.0,
      )
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(1)
    end
  end

  describe '#record_sql' do
    it do
      described_class
        .new
        .record_sql(dialect: 'mysql', statement: 'SELECT * FROM users WHERE id = ?', binds: [1]) do
          # execute sql
        end
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(1)
    end
  end

  describe '#record_from_event' do
    before { Rack::DevInsight.config.detected_dialect = 'mysql' }

    it do
      described_class.new.record_from_event(
        started: Time.now,
        finished: Time.now + 10.0,
        statement: 'SELECT * FROM users WHERE id = ?',
        binds: [1],
        cached: false,
      )
      expect(Rack::DevInsight::Context.current.result.attributes[:sql][:queries].size).to eq(1)
    end
  end
end
