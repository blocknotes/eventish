# frozen_string_literal: true

require 'rails_helper'

require 'active_record/railtie'
require 'eventish'
require 'eventish/active_record/callback'

RSpec.describe Eventish::ActiveRecord::Callback do
  let(:event_class) do
    Class.new(Eventish::SimpleEvent) do
      def call(_none, _options = {})
        puts '>>> trigger some event <<<'
      end
    end
  end

  before do
    stub_const('SomeBeforeValidationEvent', event_class)
    SomeBeforeValidationEvent.subscribe
  end

  describe '.before_validation_event' do
    let(:model_class) do
      Class.new(::ActiveRecord::Base) do
        extend ::Eventish::ActiveRecord::Callback

        self.table_name = 'users'

        before_validation_event SomeBeforeValidationEvent
      end
    end

    before { stub_const('SomeModel', model_class) }

    it do
      expect { SomeModel.new.valid? }.to output(/>>> trigger some event <<</).to_stdout
    end
  end
end
