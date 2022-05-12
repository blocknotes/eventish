# frozen_string_literal: true

module App
  class AppLoadedEvent < Eventish::SimpleEvent
    def call(_none, _options = {})
      puts '> App loaded event'
    end
  end
end
