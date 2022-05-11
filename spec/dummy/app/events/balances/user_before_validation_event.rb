# frozen_string_literal: true

module Balances
  class UserBeforeValidationEvent < Eventish::SimpleEvent
    class << self
      def call(user, _options = {})
        if user.track_expenses && user.name.blank?
          message = 'Name is required when track_expenses is enabled'
          puts message
          user.errors.add(:name, message)
        end
      end
    end
  end
end
