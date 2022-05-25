# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/main.rb', __dir__)

require 'rspec/rails'

Dir["#{__dir__}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.include ActiveJob::TestHelper

  config.before(:suite) do
    intro = ('-' * 80)
    intro << "\n"
    intro << "- Ruby:        #{RUBY_VERSION}\n"
    intro << "- Rails:       #{Rails.version}\n"
    intro << ('-' * 80)

    RSpec.configuration.reporter.message(intro)
  end
end
