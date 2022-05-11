# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Setup' do
  it 'loads the expected simple events' do
    expected_events = [
      Balances::UserAfterSaveCommitEvent,
      Balances::UserBeforeValidationEvent,
      Logs::BalanceAroundCreateEvent
    ]
    expect(Eventish::SimpleEvent.descendants.sort).to eq(expected_events)
  end

  it 'loads the expected async events' do
    expected_events = [Notifications::UserAfterSaveCommitEvent]
    expect(Eventish::AsyncEvent.descendants.sort).to eq(expected_events)
  end
end
