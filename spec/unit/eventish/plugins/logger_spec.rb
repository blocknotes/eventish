# frozen_string_literal: true

require 'eventish'
require 'eventish/plugins/logger'

RSpec.describe Eventish::Plugins::Logger do
  describe '.call' do
    let(:event_class) { Eventish::SimpleEvent }
    let(:event) { double(:event, class: event_class) }
    let(:target) { double(:target) }
    let(:args) { double(:args) }

    it 'prints a log string to stdout' do
      expected_output = /\A\[(.+)?\] EVENT: after Eventish::SimpleEvent on #<Double(.+)?>\Z/
      expect { described_class.call(target, args, event: event, hook: :after) }.to output(expected_output).to_stdout
    end
  end
end
