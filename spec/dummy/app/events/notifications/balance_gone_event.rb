# frozen_string_literal: true

module Notifications
  class BalanceGoneEvent < Eventish::SimpleEvent
    def call(balance, _options = {})
      Rails.logger.info ">>> BalanceGoneEvent: #{balance}"
    end

    class << self
      def after_event
        [Eventish::Plugins::RailsLogger]
      end
    end
  end
end
