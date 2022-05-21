# frozen_string_literal: true

module Eventish
  class ActiveJobEvent < ::ActiveJob::Base
    def call(_target, _args, &_block)
      raise NotImplementedError
    end

    def perform(target, args)
      self.class.before_event.each { |plugin| plugin.call(target, args, event: self, hook: :before) }
      call(target, args)
      self.class.after_event.each { |plugin| plugin.call(target, args, event: self, hook: :after) }
      self
    end

    class << self
      include Eventish::EventApi

      def trigger(target, args, &_block)
        perform_later(target, args)
      end
    end
  end
end
