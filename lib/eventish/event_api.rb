# frozen_string_literal: true

module Eventish
  module EventApi
    def <=>(other)
      other&.priority <=> priority
    end

    def event_name
      # If event_name is not set, infer the event from the class name
      @event_name ||= Eventish.underscore(to_s).delete_suffix('_event')
    end

    def priority
      0
    end

    def subscribe
      Eventish.adapter.subscribe(event_name, self)
    end

    def subscribe_all
      # iterate the descendants
      ObjectSpace.each_object(singleton_class).sort.each(&:subscribe)
    end
  end
end
