# frozen_string_literal: true

require 'active_record/railtie'
require 'eventish'
require 'eventish/callback'

RSpec.describe Eventish::Callback do
  let(:some_model) do
    Class.new(ActiveRecord::Base) do
      self.table_name = 'users'

      after_initialize ::Eventish::Callback
    end
  end
  let(:adapter) { double('Adapter', publish: true) }

  before do
    config = YAML.load_file Rails.root.join('config/database.yml')
    ActiveRecord::Base.establish_connection(config['test'])
    stub_const('SomeModel', some_model)
    allow(Eventish.config).to receive(:adapter).and_return(adapter)
  end

  it do
    target = SomeModel.new
    expect(adapter).to have_received(:publish).with('some_model_after_initialize', target)
  end
end
