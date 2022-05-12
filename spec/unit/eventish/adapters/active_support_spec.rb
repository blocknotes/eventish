# frozen_string_literal: true

require 'rails'

require 'eventish'
require 'eventish/adapters/active_support'

RSpec.describe Eventish::Adapters::ActiveSupport do
  describe '.publish' do
    before do
      allow(ActiveSupport::Notifications).to receive(:instrument)
    end

    it 'calls instrument on ActiveSupport::Notifications' do
      described_class.publish('some_event', :some_target)
      expect(ActiveSupport::Notifications).to have_received(:instrument).with(
        'some_event',
        event_options: {},
        target: :some_target
      )
    end
  end

  describe '.subscribe' do
    before do
      t1 = Time.now - 1
      t2 = Time.now
      id = 1234
      payload = {}
      allow(ActiveSupport::Notifications).to receive(:subscribe).and_yield('some_event', t1, t2, id, payload)
    end

    it 'calls subscribe on ActiveSupport::Notifications', :aggregate_failures do
      some_handler = class_double('Handler', trigger: true)
      described_class.subscribe('some_event', some_handler)
      expect(ActiveSupport::Notifications).to have_received(:subscribe).with('some_event')
      expect(some_handler).to have_received(:trigger)
    end
  end

  describe '.unsubscribe' do
    before do
      allow(ActiveSupport::Notifications).to receive(:unsubscribe)
    end

    it 'calls unsubscribe on ActiveSupport::Notifications', :aggregate_failures do
      described_class.unsubscribe('some_event')
      expect(ActiveSupport::Notifications).to have_received(:unsubscribe)
    end
  end
end
