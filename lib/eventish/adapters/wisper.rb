# frozen_string_literal: true

module Eventish
  module Adapters
    class Wisper
      class << self
        include ::Wisper::Publisher

        def publish(event, target = nil, block: nil)
          raise ArgumentError, 'Missing event to publish' if event.nil?

          options = block ? { block: block } : {} # TODO: verify block feature
          broadcast(event.to_s, target, options)
        end

        def subscribe(event, handler)
          raise ArgumentError, 'Missing event to subscribe' if event.nil?
          raise ArgumentError, 'Missing handler for subscription' if handler.nil?

          ::Wisper.subscribe(handler.new, on: event.to_s, with: :call).tap do |subscriber|
            Eventish.subscribers[event.to_s] = subscriber
          end
        end

        def unsubscribe(event)
          raise ArgumentError, 'Missing event to unsubscribe' if event.nil?

          subscriber = Eventish.subscribers[event.to_s]
          ::Wisper.unsubscribe(subscriber)
          Eventish.subscribers.delete(event.to_s)
        end
      end
    end
  end
end
