# frozen_string_literal: true

require 'active_job/railtie'
require 'eventish'
require 'eventish/active_job_event'

RSpec.describe Eventish::ActiveJobEvent do
  describe 'event API methods' do
    it 'responds to the required class methods', :aggregate_failures do
      expect(described_class).to respond_to(:<=>)
      expect(described_class).to respond_to(:subscribe)
      expect(described_class).to respond_to(:trigger)
    end

    it { is_expected.to respond_to(:call) }
    it { is_expected.to respond_to(:perform) }
  end

  describe '.trigger' do
    subject(:trigger) { described_class.trigger(nil, nil) }

    before do
      allow(described_class).to receive(:perform_later)
    end

    it do
      trigger
      expect(described_class).to have_received(:perform_later)
    end
  end

  describe '#call' do
    let(:event) { described_class.new }

    it 'raises NotImplementedError' do
      expect { event.call(:some_event, :some_args) }.to raise_exception(NotImplementedError)
    end
  end

  describe '#perform' do
    let(:event) { described_class.new }

    it 'raises NotImplementedError' do
      expect { event.perform(:some_event, :some_args) }.to raise_exception(NotImplementedError)
    end

    context 'with a call method' do
      let(:event_class) do
        Class.new(Eventish::ActiveJobEvent) do
          def call(_target, _options)
            # call method
          end

          class << self
            include Eventish::EventApi
          end
        end
      end

      before do
        stub_const('SomeTestEvent', event_class)
      end

      it 'calls the perform method', :aggregate_failures do
        some_event = SomeTestEvent.new
        allow(some_event).to receive(:call)
        expect { some_event.perform(:some_event, :some_args) }.not_to raise_exception
        expect(some_event).to have_received(:call).with(:some_event, :some_args)
      end
    end
  end
end
