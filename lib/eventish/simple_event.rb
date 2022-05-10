# frozen_string_literal: true

module Eventish
  class SimpleEvent
    class << self
      include EventApi
    end
  end
end
