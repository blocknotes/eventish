# frozen_string_literal: true

require_relative 'eventish/event_api'
require_relative 'eventish/simple_event'

module Eventish
  OPTIONS = %i[adapter].freeze

  AdapterError = Class.new(StandardError)

  module_function

  def adapter
    config.adapter
  end

  def config
    @options ||= Struct.new(*OPTIONS).new # rubocop:disable Naming/MemoizedInstanceVariableName
  end

  def publish(event_name, target = nil, options: {})
    config.adapter&.publish(event_name, target, options: options)
  end

  def setup
    @options ||= Struct.new(*OPTIONS).new
    yield(@options) if block_given?
    raise AdapterError, 'Please specify an event adapter' unless @options.adapter

    @options
  end
end
