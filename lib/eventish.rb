# frozen_string_literal: true

require_relative 'eventish/event_api'
require_relative 'eventish/simple_event'

module Eventish
  OPTIONS = %i[adapter after_event before_event].freeze

  AdapterError = Class.new(StandardError)

  module_function

  def adapter
    config.adapter
  end

  def config
    @options ||= Struct.new(*OPTIONS).new # rubocop:disable Naming/MemoizedInstanceVariableName
  end

  # From Rails 6.0
  def descendants(klass)
    descendants = []
    ObjectSpace.each_object(klass.singleton_class) do |k|
      next if k.singleton_class?

      descendants.unshift k unless k == self
    end
    descendants
  end

  def publish(event_name, target = nil, block: nil)
    config.adapter&.publish(event_name, target, block: block)
  end

  def setup
    @options ||= Struct.new(*OPTIONS).new
    yield(@options) if block_given?
    raise AdapterError, 'Please specify an event adapter' unless @options.adapter

    @options
  end

  def subscribers
    @subscribers ||= {}
  end
end
