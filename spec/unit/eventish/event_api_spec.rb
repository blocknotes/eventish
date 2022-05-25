# frozen_string_literal: true

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

  before do
    stub_const('FirstEvent', event1)
    stub_const('SecondEvent', event2)
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

  describe '#after_event' do
    it { expect(event1.after_event).to be_empty }

    context 'when after_event is configured' do
      let(:plugin) do
        ->(_target, _args, event:, hook:, &_block) { puts "#{hook}: #{event}" }
      end

      before do
        allow(Eventish.config).to receive(:after_event).and_return [plugin]
      end

      it('includes the expected plugin') { expect(event1.after_event).to match_array(plugin) }
    end
  end

  describe '#before_event' do
    it 'returns an empty array' do
      expect(event1.before_event).to eq []
    end

    context 'when before_event is configured' do
      let(:plugin) do
        ->(_target, _args, event:, hook:, &_block) { puts "#{hook}: #{event}" }
      end

      before do
        allow(Eventish.config).to receive(:before_event).and_return [plugin]
      end

      it('includes the expected plugin') { expect(event1.before_event).to match_array(plugin) }
    end
  end

  describe '#event_name' do
    it 'returns the event name' do
      expect(FirstEvent.event_name).to eq 'FirstEvent'
    end
  end

  describe '#priority' do
    it { expect(event1.priority).to eq 0 }
  end

  describe '#subscribe' do
    let(:adapter) { double('adapter') }

    before do
      allow(Eventish).to receive(:adapter).and_return(adapter)
      allow(adapter).to receive(:subscribe)
    end

    it 'calls the adapter subscribe method' do
      event1.subscribe
      expect(adapter).to have_received(:subscribe).with(FirstEvent.to_s, FirstEvent)
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
      stub_const('ThirdEvent', event3)
      allow(adapter).to receive(:subscribe)
      allow(Eventish.config).to receive(:adapter).and_return(adapter)
    end

    it 'subscribes to all events', :aggregate_failures do
      FirstEvent.subscribe_all
      expect(adapter).to have_received(:subscribe).with('ThirdEvent', event3)
      expect(adapter).to have_received(:subscribe).with('FirstEvent', event1)
      expect(adapter).not_to have_received(:subscribe).with('SecondEvent', anything)
    end
  end

  describe '#unsubscribe' do
    let(:adapter) { double('adapter') }

    before do
      allow(Eventish).to receive(:adapter).and_return(adapter)
      allow(adapter).to receive(:unsubscribe)
    end

    it 'calls the adapter unsubscribe method' do
      event1.unsubscribe
      expect(adapter).to have_received(:unsubscribe).with(FirstEvent.to_s)
    end
  end
end
