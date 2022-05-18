# frozen_string_literal: true

module Eventish
  module EventApi
    def <=>(other)
      other&.priority <=> priority
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
      ObjectSpace.each_object(singleton_class).sort.each(&:subscribe)
    end
  end
end
