# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trigger events' do
  describe 'validation events' do
    let(:user) { User.new }
    let(:event) { Balances::UserBeforeValidationEvent.new }

    before do
      allow(Balances::UserBeforeValidationEvent).to receive(:new).and_return(event)
      allow(event).to receive(:call)
      user.valid?
    end

    it 'triggers the expected events' do
      expect(event).to have_received(:call).with(user, a_hash_including(event: 'user_before_validation'))
    end
  end

  describe 'commit events' do
    let(:user) { User.new }
    let(:event) { Balances::UserAfterCommitEvent.new }

    before do
      allow(Balances::UserAfterCommitEvent).to receive(:new).and_return(event)
      allow(event).to receive(:call)
      user.save!
    end

    it 'triggers the expected events' do
      # expect {
      #   user.save!
      # }.to have_enqueued_job(Notifications::UserAfterSaveCommitEvent)

      expect(event).to have_received(:call).with(user, a_hash_including(event: 'user_after_commit'))
    end
  end

  describe 'custom event workflow' do
    let(:some_object) { instance_double(Object) }
    let(:test1) do
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
    let(:subscription) { Test1.subscribe }

    before do
      stub_const('Test1', test1)
      allow(Test1).to receive(:trigger)
      Test1.subscribe
    end

    it 'triggers the expected events', :aggregate_failures do
      expect(Test1).not_to have_received(:trigger)
      Eventish.publish('some_event', some_object)

      expected_attrs = {
        event: 'some_event',
        start: a_kind_of(Time),
        finish: a_kind_of(Time),
        id: anything
      }
      expect(Test1).to have_received(:trigger).with(some_object, expected_attrs)
    end
  end
end
