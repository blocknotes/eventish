# frozen_string_literal: true

require_relative 'eventish/event_api'
require_relative 'eventish/simple_event'

module Eventish
  OPTIONS = %i[adapter].freeze

  MissingAdapterError = Class.new(StandardError)

  module_function

  def adapter
    config.adapter
  end

  def config
    @options ||= Struct.new(*OPTIONS).new # rubocop:disable Naming/MemoizedInstanceVariableName
  end

  def setup
    @options ||= Struct.new(*OPTIONS).new
    yield(@options) if block_given?
    raise MissingAdapterError, 'Please specify an event adapter' unless @options.adapter

    @options
  end

  def underscore(camel_cased_word)
    return camel_cased_word.to_s unless /[A-Z-]|::/.match?(camel_cased_word)

    word = camel_cased_word.to_s.gsub(/\A.*::/, '')
    word.gsub!(/([A-Z]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) { ($1 || $2) << "_" }
    word.tr!("-", "_")
    word.downcase!
    word
  end
end
