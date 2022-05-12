# frozen_string_literal: true

require 'active_job/railtie'
require 'eventish'
require 'eventish/active_job_event'

RSpec.describe Eventish::ActiveJobEvent do
  describe 'event API methods' do
    it 'responds to the required class methods', :aggregate_failures do
      expect(described_class).to respond_to(:<=>)
      expect(described_class).to respond_to(:subscribe)
      expect(described_class).to respond_to(:trigger)
    end

    it { is_expected.to respond_to(:call) }
    it { is_expected.to respond_to(:perform) }
  end

  describe '#call' do
    let(:event) { described_class.new }

    it 'raises NotImplementedError' do
      expect { event.call(:some_event, :some_args) }.to raise_exception(NotImplementedError)
    end
  end
end
