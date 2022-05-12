# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/main.rb', __dir__)

require 'pry'

Dir["#{__dir__}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.include ActiveJob::TestHelper
end
