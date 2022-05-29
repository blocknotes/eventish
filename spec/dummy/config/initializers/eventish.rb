# frozen_string_literal: true

require 'eventish/active_job_event'
require 'eventish/active_record/callback'
require 'eventish/adapters/active_support'
require 'eventish/plugins/rails_logger'

Rails.configuration.to_prepare do
  # NOTE: required to load the event descendants when eager_load is off
  unless Rails.configuration.eager_load
    events = Rails.root.join('app/events/**/*.rb').to_s
    Dir[events].sort.each { |event| require event }
  end
end
