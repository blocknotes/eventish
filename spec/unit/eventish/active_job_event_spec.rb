# frozen_string_literal: true

require 'active_job/railtie'
require 'eventish/active_job_event'

RSpec.describe Eventish::ActiveJobEvent do
  describe 'events API' do
    it { expect(described_class.singleton_class).to include Eventish::EventApi }
  end

  describe '.trigger' do
    subject(:trigger) { described_class.trigger(:some_target, :some_args) }

    before do
      allow(described_class).to receive(:perform_later)
    end

    it do
      trigger
      expect(described_class).to have_received(:perform_later).with(:some_target, :some_args)
    end
  end

  describe '#call' do
    let(:event) { described_class.new }

    it 'raises NotImplementedError' do
      expect { event.call(:some_event, :some_args) }.to raise_exception(NotImplementedError)
    end
  end

  describe '#callable?' do
    let(:event) { described_class.new }

    it 'returns true' do
      expect(event).to be_callable(:some_target)
    end
  end

  describe '#perform' do
    let(:event) { described_class.new }

    before do
      allow(event).to receive(:call)
    end

    it do
      event.perform(:some_event, :some_args)
      expect(event).to have_received(:call).with(:some_event, :some_args)
    end

    context 'when before_event is defined' do
      before do
        plugin = ->(_target, _args, event:, hook:, &_block) { puts "#{hook}: #{event}" }
        allow(described_class).to receive(:before_event).and_return([plugin])
      end

      it do
        expected_output = /\Abefore: #<Eventish::ActiveJobEvent.*>\Z/
        expect { event.perform(:some_event, :some_args) }.to output(expected_output).to_stdout
      end
    end

    context 'when after_event is defined' do
      before do
        plugin = ->(_target, _args, event:, hook:, &_block) { puts "#{hook}: #{event}" }
        allow(described_class).to receive(:after_event).and_return([plugin])
      end

      it do
        expected_output = /\Aafter: #<Eventish::ActiveJobEvent.*>\Z/
        expect { event.perform(:some_event, :some_args) }.to output(expected_output).to_stdout
      end
    end
  end
end
