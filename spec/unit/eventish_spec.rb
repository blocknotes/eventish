# frozen_string_literal: true

require 'eventish'

RSpec.describe Eventish do
  describe '.config' do
    it 'returns a configuration object' do
      expect(described_class.config).to be_a Struct
    end
  end

  describe '.setup' do
    context 'when an adapter is not set' do
      it 'raises MissingAdapterError' do
        expect do
          described_class.setup { |config| config.adapter = nil }
        end.to raise_exception(Eventish::MissingAdapterError)
      end
    end

    context 'when an adapter is provided' do
      it 'changes the config adapter' do
        adapter = double('Adapter')

        expect do
          described_class.setup { |config| config.adapter = adapter }
        end.to change(described_class.config, :adapter).to(adapter)
      end
    end
  end
end
