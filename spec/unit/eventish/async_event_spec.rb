# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Eventish::AsyncEvent do
  describe 'event API methods' do
    it 'responds to the required class methods', :aggregate_failures do
      expect(described_class.respond_to?(:<=>)).to be_truthy
      expect(described_class.respond_to?(:call)).to be_truthy
      expect(described_class.respond_to?(:subscribe)).to be_truthy
    end

    it 'responds to the required instance methods' do
      event = described_class.new

      expect(event.respond_to?(:perform)).to be_truthy
    end
  end
end
