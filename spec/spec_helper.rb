# frozen_string_literal: true

require 'eventish'

require 'pry'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

RSpec.configure do |config|
  config.color = true
  config.disable_monkey_patching!
  config.order = :random
  config.tty = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.after do |example|
    # An extra check to ensure no subscribers are left in the system
    expect(Eventish.subscribers).to be_empty unless example.metadata[:skip_subscribers_check]
  end
end
