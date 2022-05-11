# frozen_string_literal: true

module Balances
  class UserAfterSaveCommitEvent < Eventish::SimpleEvent
    class << self
      def call(user, _options = {})
        if user.saved_change_to_track_expenses? && user.track_expenses
          user.balances.find_or_create_by!(date: Date.today)
        end
      end

      def priority
        10
      end
    end
  end
end
