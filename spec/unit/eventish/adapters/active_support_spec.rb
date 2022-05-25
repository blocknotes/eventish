# frozen_string_literal: true

require 'rails'
require 'eventish/adapters/active_support'

RSpec.describe Eventish::Adapters::ActiveSupport do
  describe '.publish' do
    before do
      allow(ActiveSupport::Notifications).to receive(:instrument)
    end

    it 'calls instrument on ActiveSupport::Notifications' do
      described_class.publish('some_event', :some_target)
      expected_attrs = { options: { block: nil }, target: :some_target }
      expect(ActiveSupport::Notifications).to have_received(:instrument).with('some_event', expected_attrs)
    end

    context 'when the event is missing' do
      it do
        expect do
          described_class.publish(nil, :some_target)
        end.to raise_exception(ArgumentError, 'Missing event to publish')
      end
    end
  end

  describe '.subscribe' do
    let(:subscribers) { {} }

    before do
      t1 = Time.now - 1
      t2 = Time.now
      id = 1234
      payload = {}
      allow(ActiveSupport::Notifications).to receive(:subscribe).and_yield('some_event', t1, t2, id, payload)
      allow(Eventish).to receive(:subscribers).and_return(subscribers)
    end

    it 'calls subscribe on ActiveSupport::Notifications', :aggregate_failures do
      some_handler = class_double('Handler', trigger: true)
      expect {
        described_class.subscribe('some_event', some_handler)
      }.to change { subscribers }.from({}).to('some_event' => true)
      expect(ActiveSupport::Notifications).to have_received(:subscribe).with('some_event')
      expect(some_handler).to have_received(:trigger)
    end

    context 'when the event is missing' do
      it do
        expect do
          described_class.subscribe(nil, :some_target)
        end.to raise_exception(ArgumentError, 'Missing event to subscribe')
      end
    end

    context 'when the handler is missing' do
      it do
        expect do
          described_class.subscribe(:some_event, nil)
        end.to raise_exception(ArgumentError, 'Missing handler for subscription')
      end
    end
  end

  describe '.unsubscribe' do
    let(:subscribers) do
      { 'an_event' => 'ASubscriber', 'some_event' => 'SomeSubscriber', 'last_event' => 'LastSubscriber' }
    end

    before do
      allow(ActiveSupport::Notifications).to receive(:unsubscribe)
      allow(Eventish).to receive(:subscribers).and_return(subscribers)
    end

    it 'calls unsubscribe on ActiveSupport::Notifications', :aggregate_failures do
      expect {
        described_class.unsubscribe('some_event')
      }.to change { subscribers }.from(
        'an_event' => 'ASubscriber', 'some_event' => 'SomeSubscriber', 'last_event' => 'LastSubscriber'
      ).to('an_event' => 'ASubscriber', 'last_event' => 'LastSubscriber')
      expect(ActiveSupport::Notifications).to have_received(:unsubscribe)
    end

    context 'when the event is missing' do
      it do
        expect do
          described_class.unsubscribe(nil)
        end.to raise_exception(ArgumentError, 'Missing event to unsubscribe')
      end
    end
  end
end
