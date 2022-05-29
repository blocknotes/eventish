# frozen_string_literal: true

require 'rails_helper'
require 'active_record/railtie'
require 'eventish/adapters/active_support'
require 'eventish/active_record/callback'

RSpec.describe 'Callbacks' do
  shared_context 'with some event' do |event_name|
    before do
      Eventish.setup do |config|
        config.adapter = Eventish::Adapters::ActiveSupport
      end

      stub_const('SomeModel', model_class)
      stub_const(event_name, event_class)
      Kernel.const_get(event_name).subscribe
    end

    after do
      Kernel.const_get(event_name).unsubscribe
    end
  end

  let(:event_class) do
    Class.new(Eventish::SimpleEvent) do
      def call(_none, _options = {})
        puts "> trigger event: #{self.class}"
        if block_given?
          yield
          puts "> block called"
        end
      end
    end
  end
  let(:model_class) do
    Class.new(::ActiveRecord::Base) do
      extend ::Eventish::ActiveRecord::Callback

      self.table_name = 'users'
    end
  end

  # Init events
  describe '.after_initialize_event' do
    include_context 'with some event', 'SomeAfterInitializeEvent'

    before do
      SomeModel.class_eval { after_initialize_event SomeAfterInitializeEvent }
    end

    it do
      expect { SomeModel.new.valid? }.to output(/trigger event: SomeAfterInitializeEvent/).to_stdout
    end
  end

  describe '.after_find_event' do
    include_context 'with some event', 'SomeAfterFindEvent'

    before do
      SomeModel.class_eval { after_find_event SomeAfterFindEvent }
    end

    it do
      instance = SomeModel.create!
      expect { SomeModel.find(instance.id) }.to output(/trigger event: SomeAfterFindEvent/).to_stdout
    end
  end

  # Validation events
  describe '.before_validation_event' do
    include_context 'with some event', 'SomeBeforeValidationEvent'

    before do
      SomeModel.class_eval { before_validation_event SomeBeforeValidationEvent }
    end

    it do
      expect { SomeModel.new.valid? }.to output(/trigger event: SomeBeforeValidationEvent/).to_stdout
    end
  end

  describe '.after_validation_event' do
    include_context 'with some event', 'SomeAfterValidationEvent'

    before do
      SomeModel.class_eval { after_validation_event SomeAfterValidationEvent }
    end

    it do
      expect { SomeModel.new.valid? }.to output(/trigger event: SomeAfterValidationEvent/).to_stdout
    end
  end

  # Create events
  describe '.before_create_event' do
    include_context 'with some event', 'SomeBeforeCreateEvent'

    before do
      SomeModel.class_eval { before_create_event SomeBeforeCreateEvent }
    end

    it do
      expect { SomeModel.create! }.to output(/trigger event: SomeBeforeCreateEvent/).to_stdout
    end
  end

  describe '.around_create_event' do
    include_context 'with some event', 'SomeAroundCreateEvent'

    before do
      SomeModel.class_eval { around_create_event SomeAroundCreateEvent }
    end

    it do
      expect { SomeModel.create! }.to output(/trigger event: SomeAroundCreateEvent.*block called/m).to_stdout
    end
  end

  describe '.after_create_event' do
    include_context 'with some event', 'SomeAfterCreateEvent'

    before do
      SomeModel.class_eval { after_create_event SomeAfterCreateEvent }
    end

    it do
      expect { SomeModel.create! }.to output(/trigger event: SomeAfterCreateEvent/).to_stdout
    end
  end

  # Update events
  describe '.before_update_event' do
    include_context 'with some event', 'SomeBeforeUpdateEvent'

    before do
      SomeModel.class_eval { before_update_event SomeBeforeUpdateEvent }
    end

    it do
      instance = SomeModel.create!
      expect { instance.update!(name: 'Test') }.to output(/trigger event: SomeBeforeUpdateEvent/).to_stdout
    end
  end

  describe '.around_update_event' do
    include_context 'with some event', 'SomeAroundUpdateEvent'

    before do
      SomeModel.class_eval { around_update_event SomeAroundUpdateEvent }
    end

    it do
      instance = SomeModel.create!
      expected_output = /trigger event: SomeAroundUpdateEvent.*block called/m
      expect { instance.update!(name: 'Test') }.to output(expected_output).to_stdout
    end
  end

  describe '.after_update_event' do
    include_context 'with some event', 'SomeAfterUpdateEvent'

    before do
      SomeModel.class_eval { after_update_event SomeAfterUpdateEvent }
    end

    it do
      instance = SomeModel.create!
      expect { instance.update!(name: 'Test') }.to output(/trigger event: SomeAfterUpdateEvent/).to_stdout
    end
  end

  # Save events
  describe '.before_save_event' do
    include_context 'with some event', 'SomeBeforeSaveEvent'

    before do
      SomeModel.class_eval { before_save_event SomeBeforeSaveEvent }
    end

    it do
      expect { SomeModel.create! }.to output(/trigger event: SomeBeforeSaveEvent/).to_stdout
    end
  end

  describe '.around_save_event' do
    include_context 'with some event', 'SomeAroundSaveEvent'

    before do
      SomeModel.class_eval { around_save_event SomeAroundSaveEvent }
    end

    it do
      expect { SomeModel.create! }.to output(/trigger event: SomeAroundSaveEvent.*block called/m).to_stdout
    end
  end

  describe '.after_save_event' do
    include_context 'with some event', 'SomeAfterSaveEvent'

    before do
      SomeModel.class_eval { after_save_event SomeAfterSaveEvent }
    end

    it do
      expect { SomeModel.create! }.to output(/trigger event: SomeAfterSaveEvent/).to_stdout
    end
  end

  # Destroy events
  describe '.before_destroy_event' do
    include_context 'with some event', 'SomeBeforeDestroyEvent'

    before do
      SomeModel.class_eval { before_destroy_event SomeBeforeDestroyEvent }
    end

    it do
      instance = SomeModel.create!
      expect { instance.destroy! }.to output(/trigger event: SomeBeforeDestroyEvent/).to_stdout
    end
  end

  describe '.around_destroy_event' do
    include_context 'with some event', 'SomeAroundDestroyEvent'

    before do
      SomeModel.class_eval { around_destroy_event SomeAroundDestroyEvent }
    end

    it do
      instance = SomeModel.create!
      expect { instance.destroy! }.to output(/trigger event: SomeAroundDestroyEvent.*block called/m).to_stdout
    end
  end

  describe '.after_destroy_event' do
    include_context 'with some event', 'SomeAfterDestroyEvent'

    before do
      SomeModel.class_eval { after_destroy_event SomeAfterDestroyEvent }
    end

    it do
      instance = SomeModel.create!
      expect { instance.destroy! }.to output(/trigger event: SomeAfterDestroyEvent/).to_stdout
    end
  end

  # Commit events
  describe '.after_commit_event' do
    include_context 'with some event', 'SomeAfterCommitEvent'

    let(:new_instance) { SomeModel.create! }

    before do
      SomeModel.class_eval { after_commit_event SomeAfterCommitEvent }
    end

    it do
      aggregate_failures do
        expect { new_instance }.to output(/trigger event: SomeAfterCommitEvent/).to_stdout
        expect { new_instance.update(name: 'Test') }.to output(/trigger event: SomeAfterCommitEvent/).to_stdout
        expect { new_instance.destroy }.to output(/trigger event: SomeAfterCommitEvent/).to_stdout
      end
    end
  end

  describe '.after_create_commit_event' do
    include_context 'with some event', 'SomeAfterCreateCommitEvent'

    let(:new_instance) { SomeModel.create! }

    before do
      SomeModel.class_eval { after_create_commit_event SomeAfterCreateCommitEvent }
    end

    it do
      aggregate_failures do
        expect { new_instance }.to output(/trigger event: SomeAfterCreateCommitEvent/).to_stdout
        expect { new_instance.update(name: 'Test') }.not_to output(/trigger event/).to_stdout
        expect { new_instance.destroy }.not_to output(/trigger event/).to_stdout
      end
    end
  end

  describe '.after_update_commit_event' do
    include_context 'with some event', 'SomeAfterUpdateCommitEvent'

    let(:new_instance) { SomeModel.create! }

    before do
      SomeModel.class_eval { after_update_commit_event SomeAfterUpdateCommitEvent }
    end

    it do
      aggregate_failures do
        expect { new_instance }.not_to output(/trigger event/).to_stdout
        expect { new_instance.update(name: 'Test') }.to output(/trigger event: SomeAfterUpdateCommitEvent/).to_stdout
        expect { new_instance.destroy }.not_to output(/trigger event/).to_stdout
      end
    end
  end

  describe '.after_save_commit_event' do
    include_context 'with some event', 'SomeAfterSaveCommitEvent'

    let(:new_instance) { SomeModel.create! }

    before do
      SomeModel.class_eval { after_save_commit_event SomeAfterSaveCommitEvent }
    end

    it do
      aggregate_failures do
        expect { new_instance }.to output(/trigger event: SomeAfterSaveCommitEvent/).to_stdout
        expect { new_instance.update(name: 'Test') }.to output(/trigger event: SomeAfterSaveCommitEvent/).to_stdout
        expect { new_instance.destroy }.not_to output(/trigger event/).to_stdout
      end
    end
  end

  describe '.after_destroy_commit_event' do
    include_context 'with some event', 'SomeAfterDestroyCommitEvent'

    let(:new_instance) { SomeModel.create! }

    before do
      SomeModel.class_eval { after_destroy_commit_event SomeAfterDestroyCommitEvent }
    end

    it do
      aggregate_failures do
        expect { new_instance }.not_to output(/trigger event/).to_stdout
        expect { new_instance.update(name: 'Test') }.not_to output(/trigger event/).to_stdout
        expect { new_instance.destroy }.to output(/trigger event: SomeAfterDestroyCommitEvent/).to_stdout
      end
    end
  end

  describe '.after_rollback_event' do
    include_context 'with some event', 'SomeRollbackCommitEvent'

    let(:rollback) do
      SomeModel.transaction do
        SomeModel.create!
        raise ActiveRecord::Rollback
      end
    end

    before do
      SomeModel.class_eval { after_rollback_event SomeRollbackCommitEvent }
    end

    it do
      expect { rollback }.to output(/trigger event: SomeRollbackCommitEvent/).to_stdout
    end
  end

  # Touch events
  describe '.after_touch_event' do
    include_context 'with some event', 'SomeAfterTouchEvent'

    before do
      SomeModel.class_eval { after_touch_event SomeAfterTouchEvent }
    end

    it do
      instance = SomeModel.create!
      expect { instance.touch }.to output(/trigger event: SomeAfterTouchEvent/).to_stdout
    end
  end
end
