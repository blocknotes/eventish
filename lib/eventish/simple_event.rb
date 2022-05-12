# frozen_string_literal: true

module Eventish
  class SimpleEvent
    def call(_target, _args, &_block)
      raise NotImplementedError
    end

    class << self
      include EventApi

      def trigger(target, args, &block)
        new.call(target, args, &block)
      end
    end
  end
end
