# frozen_string_literal: true

module Eventish
  class Adapters
    class ActiveSupport
      class << self
        def publish(event, target = nil, options: {})
          raise ArgumentError, 'Missing event to publish' if event.nil?

          ::ActiveSupport::Notifications.instrument(event.to_s, target: target, event_options: options)
        end

        def subscribe(event, handler)
          raise ArgumentError, 'Missing event to subscribe' if event.nil?
          raise ArgumentError, 'Missing handler for subscription' if handler.nil?

          ::ActiveSupport::Notifications.subscribe(event.to_s) do |name, start, finish, id, payload|
            args = { event: name, id: id, start: start, finish: finish }
            handler.trigger(payload[:target], args, &payload.dig(:event_options, :block))
          end
        end

        def unsubscribe(event)
          raise ArgumentError, 'Missing event to unsubscribe' if event.nil?

          ::ActiveSupport::Notifications.unsubscribe(event.to_s)
        end
      end
    end
  end
end
