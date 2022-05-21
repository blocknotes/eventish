# frozen_string_literal: true

require 'eventish'

RSpec.describe Eventish::EventApi do
  let(:event1) do
    Class.new do
      class << self
        include Eventish::EventApi
      end
    end
  end
  let(:event2) do
    Class.new do
      class << self
        include Eventish::EventApi
      end
    end
  end

  describe '#<=>' do
    it 'returns 0 if the priority is the same' do
      allow(event1).to receive(:priority).and_return(1)
      allow(event2).to receive(:priority).and_return(1)
      expect(event1 <=> event2).to eq 0
    end

    it 'returns -1 if the priority is greater than the other' do
      allow(event1).to receive(:priority).and_return(50)
      allow(event2).to receive(:priority).and_return(5)
      expect(event1 <=> event2).to eq(-1)
    end

    it 'returns 1 if the priority is less than the other' do
      allow(event1).to receive(:priority).and_return(0)
      allow(event2).to receive(:priority).and_return(99)
      expect(event1 <=> event2).to eq 1
    end
  end

  describe '#event_name' do
    before { stub_const('::ANamespace::SomeTestEvent', event1) }

    it 'returns the event name' do
      expect(ANamespace::SomeTestEvent.event_name).to eq 'ANamespace::SomeTestEvent'
    end

    context 'when event_name is overridden' do
      before do
        allow(event1).to receive(:event_name).and_return('another_name')
      end

      it 'returns the overridden event name' do
        expect(ANamespace::SomeTestEvent.event_name).to eq 'another_name'
      end
    end
  end

  describe '#priority' do
    it { expect(event1.priority).to eq 0 }
  end

  describe '#subscribe' do
    let(:adapter) { double('Adapter') }

    before do
      stub_const('SomeTestEvent', event1)
      allow(adapter).to receive(:subscribe)
      allow(Eventish.config).to receive(:adapter).and_return(adapter)
    end

    it 'subscribes to the event' do
      event1.subscribe
      expect(adapter).to have_received(:subscribe).with('SomeTestEvent', event1)
    end
  end

  describe '#subscribe_all' do
    let(:event3) do
      Class.new(event1) do
        class << self
          include Eventish::EventApi
        end
      end
    end

    let(:adapter) { double('Adapter') }

    before do
      stub_const('SomeTestEvent', event1)
      stub_const('AnotherEvent', event3)
      allow(adapter).to receive(:subscribe)
      allow(Eventish.config).to receive(:adapter).and_return(adapter)
    end

    it 'subscribes to all events', :aggregate_failures do
      SomeTestEvent.subscribe_all
      expect(adapter).to have_received(:subscribe).with('SomeTestEvent', event1)
    end
  end
end
