# frozen_string_literal: true

module Eventish
  class Adapters
    class ActiveSupport
      class << self
        def publish(event_name, target = nil, options: {})
          ::ActiveSupport::Notifications.instrument(event_name, target: target, event_options: options)
        end

        def subscribe(event_name, handler)
          ::ActiveSupport::Notifications.subscribe(event_name) do |name, start, finish, id, payload|
            args = { event: name, id: id, start: start, finish: finish }
            handler.trigger(payload[:target], args, &payload[:block])
          end
        end

        def unsubscribe(event_name)
          ::ActiveSupport::Notifications.unsubscribe(event_name)
        end
      end
    end
  end
end
