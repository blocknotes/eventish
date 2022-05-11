# frozen_string_literal: true

Rails.configuration.to_prepare do
  unless Rails.configuration.eager_load
    # NOTE: needed to load the Event descendants
    events = Rails.root.join('app/events/**/*.rb').to_s
    Dir[events].sort.each { |event| require event }
  end
end

Rails.configuration.after_initialize do
  Eventish::SimpleEvent.descendants.sort.each(&:subscribe)
  Eventish::AsyncEvent.descendants.sort.each(&:subscribe)
end
