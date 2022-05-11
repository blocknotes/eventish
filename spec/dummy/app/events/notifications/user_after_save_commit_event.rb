# frozen_string_literal: true

module Notifications
  class UserAfterSaveCommitEvent < Eventish::AsyncEvent
    class << self
      def call(user, _options = {})
        puts ">>> User ##{user.id} after commit notification"
      end

      # def priority
      #   1
      # end
    end
  end
end
