# frozen_string_literal: true

require 'eventish'

RSpec.describe Eventish::SimpleEvent do
  describe 'event API methods' do
    it 'responds to the required class methods', :aggregate_failures do
      expect(described_class).to respond_to(:<=>)
      expect(described_class).to respond_to(:subscribe)
      expect(described_class).to respond_to(:trigger)
    end

    it { is_expected.to respond_to(:call) }
  end

  describe '.trigger' do
    let(:event) { described_class.new }

    before do
      allow(described_class).to receive(:new).and_return(event)
      allow(event).to receive(:call)
      described_class.trigger(:test_event, :some_args)
    end

    it { expect(event).to have_received(:call).with(:test_event, :some_args) }
  end

  describe '#call' do
    let(:event) { described_class.new }

    it 'raises NotImplementedError' do
      expect { event.call(:some_event, :some_args) }.to raise_exception(NotImplementedError)
    end
  end
end
