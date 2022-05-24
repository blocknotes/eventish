# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Setup' do
  it 'loads the expected events' do
    expected_events = [
      'Balances::UserAfterCommitEvent',
      'Balances::UserBeforeValidationEvent',
      'Logs::BalanceAroundCreateEvent',
      'App::AppLoadedEvent',
      'Notifications::BalanceGoneEvent',
      'Notifications::UserAfterSaveCommitEvent'
    ]
    expect(Eventish.subscribers.keys).to contain_exactly(*expected_events)
  end
end
