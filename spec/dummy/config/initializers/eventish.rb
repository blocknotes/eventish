# frozen_string_literal: true

require 'eventish/active_job_event'
require 'eventish/active_record/callback'
require 'eventish/adapters/active_support'
require 'eventish/plugins/rails_logger'

## Setup adapter
# Eventish.setup do |config|
#   config.adapter = Eventish::Adapters::ActiveSupport
# end

Rails.configuration.to_prepare do
  # NOTE: required to load the event descendants when eager_load is off
  unless Rails.configuration.eager_load
    events = Rails.root.join('app/events/**/*.rb').to_s
    Dir[events].sort.each { |event| require event }
  end
end

## Subscribe event classes
# Rails.configuration.after_initialize do
#   Eventish::SimpleEvent.subscribe_all
#   Eventish::ActiveJobEvent.subscribe_all
# end
