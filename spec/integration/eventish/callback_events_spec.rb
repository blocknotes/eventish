# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Callback events' do
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

  # describe 'around create events' do
  #   let(:user) { User.create! }

  #   before do
  #     allow(Logs::BalanceAroundCreateEvent).to receive(:call)
  #     user
  #   end

  #   it 'should trigger the expected events' do
  #     expect(Logs::BalanceAroundCreateEvent).to have_received(:call).with(
  #       user,
  #       a_hash_including(event: 'user_after_commit')
  #     )
  #   end
  # end
end
