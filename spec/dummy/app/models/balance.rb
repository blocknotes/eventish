# frozen_string_literal: true

class Balance < ActiveRecord::Base
  belongs_to :user

  around_create ->(_object, block) { ::Eventish.publish(Logs::BalanceAroundCreateEvent, self, options: { block: block }) }
end
