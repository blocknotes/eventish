# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Custom events' do
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
      Eventish.adapter.publish('some_event', some_object)

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
