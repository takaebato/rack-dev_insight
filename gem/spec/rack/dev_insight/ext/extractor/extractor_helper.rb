# frozen_string_literal: true

module ExtractorHelper
  # subject must be set
  RSpec.shared_examples :extracts_tables do |create:, read:, update:, delete:|
    it 'returns crud tables hash' do
      expect(subject).to eq({ 'CREATE' => create, 'READ' => read, 'UPDATE' => update, 'DELETE' => delete })
    end
  end
end
