# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trigger event' do
  describe 'with validation events' do
    let(:user) { User.new }

    before do
      allow(Balances::UserBeforeValidationEvent).to receive(:call)
      user.valid?
    end

    it 'should trigger the expected events' do
      expect(Balances::UserBeforeValidationEvent).to have_received(:call).with(
        user,
        a_hash_including(event: 'user_before_validation')
      )
    end
  end

  describe 'with commit events' do
    let(:user) { User.new }

    before do
      allow(Balances::UserAfterSaveCommitEvent).to receive(:call)
      user.save!
    end

    it 'should trigger the expected events' do
      # ActiveJob::Base.queue_adapter = :test
      # expect {
      #   user.save!
      # }.to have_enqueued_job(Notifications::UserAfterSaveCommitEvent)

      expect(Balances::UserAfterSaveCommitEvent).to have_received(:call).with(
        user,
        a_hash_including(event: 'user_after_commit')
      )
    end
  end

  # describe 'with around create events' do
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
