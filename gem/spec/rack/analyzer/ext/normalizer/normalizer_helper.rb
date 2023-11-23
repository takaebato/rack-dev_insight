# frozen_string_literal: true

module NormalizerHelper
  # subject and normalized must be set
  RSpec.shared_examples :normalize do
    it 'returns normalized statement' do
      expect(subject).to eq(normalized)
    end
  end
end
