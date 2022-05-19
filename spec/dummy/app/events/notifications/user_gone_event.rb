# frozen_string_literal: true

module Notifications
  class UserGoneEvent < Eventish::SimpleEvent
    def call(user, _options = {})
      Rails.logger.info ">>> UserGoneEvent: #{user}"
    end
  end
end
