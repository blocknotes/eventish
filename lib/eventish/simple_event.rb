# frozen_string_literal: true

module Eventish
  class SimpleEvent
    def call(_target, _args, &_block)
      raise NotImplementedError
    end

    class << self
      include EventApi

      def trigger(target, args, &block)
        event = new
        before_event.each { |plugin| plugin.call(target, args, event: event, hook: :before, &block) }
        event.call(target, args, &block)
        after_event.each { |plugin| plugin.call(target, args, event: event, hook: :after, &block) }
        event
      end
    end
  end
end
