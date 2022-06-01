# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trigger events' do
  before do
    Eventish.setup do |config|
      config.adapter = Eventish::Adapters::ActiveSupport
    end
  end

  describe 'validation events' do
    let(:user) { User.new }
    let(:event) { Balances::UserBeforeValidationEvent.new }

    before do
      allow(Balances::UserBeforeValidationEvent).to receive(:new).and_return(event)
      allow(event).to receive(:call)
      Balances::UserBeforeValidationEvent.subscribe
      user.valid?
    end

    after do
      Balances::UserBeforeValidationEvent.unsubscribe
    end

    it 'triggers the expected events' do
      event_name = ::Balances::UserBeforeValidationEvent.to_s
      expect(event).to have_received(:call).with(user, a_hash_including(event: event_name))
    end
  end

  describe 'commit events' do
    let(:user) { User.new(name: 'Mat', track_expenses: true) }
    let(:event1) { Balances::UserAfterCommitEvent.new }

    before do
      allow(Balances::UserAfterCommitEvent).to receive(:new).and_return(event1)
      allow(event1).to receive(:call)
      Balances::UserAfterCommitEvent.subscribe
      Notifications::UserAfterSaveCommitEvent.subscribe
    end

    after do
      Notifications::UserAfterSaveCommitEvent.unsubscribe
      Balances::UserAfterCommitEvent.unsubscribe
    end

    it 'triggers the expected events', :aggregate_failures do
      expect {
        user.save!
      }.to have_enqueued_job(Notifications::UserAfterSaveCommitEvent)
      expect(event1).to have_received(:call).with(user, a_hash_including(event: 'Balances::UserAfterCommitEvent'))
    end
  end

  describe 'conditional execution' do
    context 'when callable? returns true' do
      let(:test_event_class) do
        Class.new(Eventish::SimpleEvent) do
          def callable?(_target)
            true
          end

          def call(_target, _options = {})
            puts 'do something'
          end
        end
      end

      before do
        stub_const('TestEvent', test_event_class)
        TestEvent.subscribe
      end

      after do
        TestEvent.unsubscribe
      end

      it do
        expect { Eventish.publish('TestEvent', nil) }.to output(/do something/).to_stdout
      end
    end

    context 'when callable? returns false' do
      let(:test_event_class) do
        Class.new(Eventish::SimpleEvent) do
          def callable?(_target)
            false
          end

          def call(_target, _options = {})
            puts 'do something'
          end
        end
      end

      before do
        stub_const('TestEvent', test_event_class)
        TestEvent.subscribe
      end

      after do
        TestEvent.unsubscribe
      end

      it do
        expect { Eventish.publish('TestEvent', nil) }.not_to output(/do something/).to_stdout
      end
    end
  end

  describe 'custom event workflow' do
    let(:some_object) { instance_double(Object) }
    let(:test_event_class) do
      Class.new do
        class << self
          include Eventish::EventApi

          def event_name
            'some_event'
          end

          def trigger(_target, _args, &_block)
            'do something'
          end
        end
      end
    end

    before do
      stub_const('TestEvent', test_event_class)
      allow(TestEvent).to receive(:trigger)
      TestEvent.subscribe
    end

    after do
      TestEvent.unsubscribe
    end

    it 'triggers the expected events', :aggregate_failures do
      expect(TestEvent).not_to have_received(:trigger)
      Eventish.publish('some_event', some_object)

      expected_attrs = { event: 'some_event', start: a_kind_of(Time), finish: a_kind_of(Time), id: anything }
      expect(TestEvent).to have_received(:trigger).with(some_object, expected_attrs)
    end
  end
end
