# frozen_string_literal: true

module Eventish
  module EventApi
    def <=>(other)
      other&.priority <=> priority
    end

    def after_event
      Eventish.config.after_event || []
    end

    def before_event
      Eventish.config.before_event || []
    end

    def event_name
      @event_name ||= to_s
    end

    def priority
      0
    end

    def subscribe
      Eventish.adapter.subscribe(event_name, self)
    end

    def subscribe_all
      # iterate the descendants
      ignore_events = [Eventish::SimpleEvent]
      ignore_events.push(Eventish::ActiveJobEvent) if defined? Eventish::ActiveJobEvent
      events = ObjectSpace.each_object(singleton_class).sort
      (events - ignore_events).each(&:subscribe)
    end

    def unsubscribe
      Eventish.adapter.unsubscribe(event_name)
    end
  end
end
