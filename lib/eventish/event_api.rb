# frozen_string_literal: true

module Eventish
  module EventApi
    def <=>(other)
      other.priority <=> priority
    end

    def call
      raise NotImplementedError
    end

    def priority
      0
    end

    def subscribe
      # Infer the event from the class name
      event = to_s.demodulize.underscore.delete_suffix('_event')
      event = event.gsub(/_after_(create|destroy|save|update)_commit\Z/, '_after_commit')
      Callback.subscribe(event, self)
    end
  end
end
