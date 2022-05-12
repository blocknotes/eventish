# frozen_string_literal: true

module Balances
  class UserAfterCommitEvent < Eventish::SimpleEvent
    def call(user, _options = {})
      if user.saved_change_to_track_expenses? && user.track_expenses
        user.balances.find_or_create_by!(date: Date.today)
      end
    end

    class << self
      # def event_name
      #   'user_after_commit'
      # end

      def priority
        10
      end
    end
  end
end
