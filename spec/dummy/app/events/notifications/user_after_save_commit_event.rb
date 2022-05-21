# frozen_string_literal: true

module Notifications
  class UserAfterSaveCommitEvent < Eventish::ActiveJobEvent
    def call(user, _options = {})
      Rails.logger.info ">>> User ##{user.id} after commit notification"
    end

    class << self
      def priority
        9
      end
    end
  end
end
