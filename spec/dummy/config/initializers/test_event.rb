# frozen_string_literal: true

Rails.configuration.after_initialize do
  Eventish.adapter.publish('app_loaded')
end
