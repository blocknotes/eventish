# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Setup' do
  it 'loads the expected simple events' do
    expected_events = [
      Balances::UserAfterCommitEvent,
      Balances::UserBeforeValidationEvent,
      Logs::BalanceAroundCreateEvent,
      App::AppLoadedEvent,
      Notifications::UserGoneEvent
    ]
    expect(Eventish::SimpleEvent.descendants.sort).to match_array(expected_events)
  end

  it 'loads the expected ActiveJob events' do
    expected_events = [Notifications::UserAfterSaveCommitEvent]
    expect(Eventish::ActiveJobEvent.descendants.sort).to match_array(expected_events)
  end
end
