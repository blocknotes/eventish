# frozen_string_literal: true

require 'spec_helper'

# require 'simplecov'

# SimpleCov.start do
#   add_filter '/spec/'
# end

ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/main.rb', __dir__)

require 'pry'

Dir["#{__dir__}/support/**/*.rb"].sort.each { |f| require f }
