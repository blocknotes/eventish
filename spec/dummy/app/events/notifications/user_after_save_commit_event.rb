# frozen_string_literal: true

module Notifications
  class UserAfterSaveCommitEvent < Eventish::ActiveJobEvent
    def call(user, _options = {})
      Rails.logger.info ">>> User ##{user.id} after commit notification"
    end

    class << self
      def event_name
        'user_after_commit'
      end

      # def priority
      #   1
      # end
    end
  end
end
