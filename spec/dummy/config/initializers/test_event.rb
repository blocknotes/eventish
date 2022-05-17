# frozen_string_literal: true

Rails.configuration.after_initialize do
  Eventish.publish('app_loaded')
end
