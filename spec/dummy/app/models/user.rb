# frozen_string_literal: true

class User < ActiveRecord::Base
  extend ::Eventish::ActiveRecord::Callback

  has_many :balances, dependent: :destroy

  before_validation -> { ::Eventish.publish(::Balances::UserBeforeValidationEvent, self) }
  # or: before_validation_event ::Balances::UserBeforeValidationEvent

  after_commit_event ::Balances::UserAfterCommitEvent
  after_save_commit_event ::Notifications::UserAfterSaveCommitEvent
end
