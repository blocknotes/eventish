# frozen_string_literal: true

require 'rails'
require 'eventish/plugins/rails_logger'

RSpec.describe Eventish::Plugins::RailsLogger do
  describe '.call' do
    let(:logger) { Logger.new($stdout) }
    let(:event_class) { Eventish::SimpleEvent }
    let(:event) { double(:event, class: event_class) }
    let(:target) { double(:target) }
    let(:args) { double(:args) }

    before do
      allow(Rails).to receive(:logger).and_return(logger)
    end

    it 'prints a log string to stdout' do
      allow(logger).to receive(:debug)
      expected_output = /\AEVENT: after Eventish::SimpleEvent on #<Double(.+)?>\Z/
      described_class.call(target, args, event: event, hook: :after)
      expect(logger).to have_received(:debug).with(expected_output)
    end
  end
end
