# frozen_string_literal: true

require 'rails_helper'
require 'eventish/adapters/active_support'
require 'eventish/plugins/logger'
require 'eventish/plugins/rails_logger'

RSpec.describe 'Plugins' do
  before do
    Eventish.setup do |config|
      config.adapter = Eventish::Adapters::ActiveSupport
    end

    Balances::UserBeforeValidationEvent.subscribe
  end

  after do
    Balances::UserBeforeValidationEvent.unsubscribe
  end

  describe 'logger plugin' do
    context 'when using before hook' do
      before do
        allow(Eventish.config).to receive(:before_event).and_return([Eventish::Plugins::Logger])
      end

      it 'logs the expected events' do
        expected_output = /\A\[(.+)?\] EVENT: before Balances::UserBeforeValidationEvent on #<User(.+)?>\Z/
        expect { User.new(name: 'Mat').valid? }.to output(expected_output).to_stdout
      end
    end

    context 'when using after hook' do
      before do
        allow(Eventish.config).to receive(:after_event).and_return([Eventish::Plugins::Logger])
      end

      it 'logs the expected events' do
        expected_output = /\A\[(.+)?\] EVENT: after Balances::UserBeforeValidationEvent on #<User(.+)?>\Z/
        expect { User.new(name: 'Mat').valid? }.to output(expected_output).to_stdout
      end
    end

    context 'when using before and after hooks' do
      before do
        allow(Eventish.config).to receive(:before_event).and_return([Eventish::Plugins::Logger])
        allow(Eventish.config).to receive(:after_event).and_return([Eventish::Plugins::Logger])
      end

      it 'logs the expected events' do
        expected_output = <<~OUTPUT.chomp
          .+EVENT: before Balances::UserBeforeValidationEvent on.+
          .+EVENT: after Balances::UserBeforeValidationEvent on.+
        OUTPUT
        expect { User.new(name: 'Mat').valid? }.to output(Regexp.new(expected_output, Regexp::MULTILINE)).to_stdout
      end
    end
  end

  describe 'Rails logger plugin' do
    before do
      allow(Rails.logger).to receive(:debug)
    end

    context 'when using before hook' do
      before do
        allow(Eventish.config).to receive(:before_event).and_return([Eventish::Plugins::RailsLogger])
        User.new(name: 'Mat').valid?
      end

      it 'logs the expected events' do
        expected_output = /\AEVENT: before Balances::UserBeforeValidationEvent on #<User(.+)?>\Z/
        expect(Rails.logger).to have_received(:debug).with(expected_output)
      end
    end

    context 'when using after hook' do
      before do
        allow(Eventish.config).to receive(:after_event).and_return([Eventish::Plugins::RailsLogger])
        User.new(name: 'Mat').valid?
      end

      it 'logs the expected events' do
        expected_output = /\AEVENT: after Balances::UserBeforeValidationEvent on #<User(.+)?>\Z/
        expect(Rails.logger).to have_received(:debug).with(expected_output)
      end
    end

    context 'when using before and after hooks' do
      before do
        allow(Eventish.config).to receive(:before_event).and_return([Eventish::Plugins::RailsLogger])
        allow(Eventish.config).to receive(:after_event).and_return([Eventish::Plugins::RailsLogger])
        User.new(name: 'Mat').valid?
      end

      it 'logs the expected events', :aggregate_failures do
        expected_output = /\AEVENT: before Balances::UserBeforeValidationEvent on #<User(.+)?>\Z/
        expect(Rails.logger).to have_received(:debug).with(expected_output).ordered

        expected_output = /\AEVENT: after Balances::UserBeforeValidationEvent on #<User(.+)?>\Z/
        expect(Rails.logger).to have_received(:debug).with(expected_output).ordered
      end
    end
  end

  describe 'custom plugin' do
    before do
      custom_plugin = ->(_target, _args, event:, hook:) { puts "Custom plugin: #{event.class.name}" }
      allow(Eventish.config).to receive(:before_event).and_return([custom_plugin])
    end

    it "executes the plugin's call method" do
      expected_output = /Custom plugin: Balances::UserBeforeValidationEvent/
      expect { User.new(name: 'Mat').valid? }.to output(expected_output).to_stdout
    end
  end
end
