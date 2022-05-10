# frozen_string_literal: true

module Eventish
  class AsyncEvent < ActiveJob::Base
    def perform(target, args)
      self.class.call(target, args)
    end

    class << self
      include EventApi
    end
  end
end
