# frozen_string_literal: true

module Eventish
  class ActiveJobEvent < ::ActiveJob::Base
    def call(_target, _args, &_block)
      raise NotImplementedError
    end

    def perform(target, args)
      call(target, args)
    end

    class << self
      include Eventish::EventApi

      def trigger(target, args, &_block)
        perform_later(target, args)
      end
    end
  end
end
