# frozen_string_literal: true

class Balance < ActiveRecord::Base
  extend ::Eventish::ActiveRecord::Callback

  belongs_to :user

  around_create ->(_object, block) { ::Eventish.publish(Logs::BalanceAroundCreateEvent, self, block: block) }

  after_destroy_commit_event ::Notifications::BalanceGoneEvent
end
