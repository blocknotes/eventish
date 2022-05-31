# frozen_string_literal: true

require 'wisper'
require 'eventish/adapters/wisper'

require 'rails_helper'

RSpec.describe 'Using Wisper adapter' do
  before do
    Eventish.setup do |config|
      config.adapter = Eventish::Adapters::Wisper
    end
  end

  describe 'commit events' do
    let(:user) { User.new(name: 'Mat', track_expenses: true) }

    before do
      Balances::UserAfterCommitEvent.subscribe
    end

    after do
      Balances::UserAfterCommitEvent.unsubscribe
    end

    it 'triggers the expected events', :aggregate_failures do
      expect_any_instance_of(Balances::UserAfterCommitEvent).to receive(:call).with(user, {})
      user.save!
    end
  end

  describe 'validation events' do
    let(:user) { User.new }

    before do
      Balances::UserBeforeValidationEvent.subscribe
    end

    after do
      Balances::UserBeforeValidationEvent.unsubscribe
    end

    it 'triggers the expected events' do
      expect_any_instance_of(Balances::UserBeforeValidationEvent).to receive(:call).with(user, {})
      user.valid?
    end
  end
end
