# frozen_string_literal: true

module Eventish
  module Plugins
    class Logger
      class << self
        def call(target, _args, event:, hook: nil, &_block)
          puts "[#{Time.now}] EVENT: #{hook} #{event.class.event_name} on #{target.inspect}"
        end
      end
    end
  end
end
