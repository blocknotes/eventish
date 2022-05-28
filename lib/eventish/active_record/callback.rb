# frozen_string_literal: true

module Eventish
  module ActiveRecord
    module Callback
      # Init events
      def after_initialize_event(*args)
        event = args.shift
        after_initialize -> { ::Eventish.publish(event, self) }, *args
      end

      def after_find_event(*args)
        event = args.shift
        after_find -> { ::Eventish.publish(event, self) }, *args
      end

      # Validation events
      def before_validation_event(*args)
        event = args.shift
        before_validation -> { ::Eventish.publish(event, self) }, *args
      end

      def after_validation_event(*args)
        event = args.shift
        after_validation -> { ::Eventish.publish(event, self) }, *args
      end

      # Create events
      def before_create_event(*args)
        event = args.shift
        before_create -> { ::Eventish.publish(event, self) }, *args
      end

      def around_create_event(*args)
        event = args.shift
        around_create ->(_object, block) { ::Eventish.publish(event, self, block: block) }, *args
      end

      def after_create_event(*args)
        event = args.shift
        after_create -> { ::Eventish.publish(event, self) }, *args
      end

      # Update events
      def before_update_event(*args)
        event = args.shift
        before_update -> { ::Eventish.publish(event, self) }, *args
      end

      def around_update_event(*args)
        event = args.shift
        around_update ->(_object, block) { ::Eventish.publish(event, self, block: block) }, *args
      end

      def after_update_event(*args)
        event = args.shift
        after_update -> { ::Eventish.publish(event, self) }, *args
      end

      # Save events
      def before_save_event(*args)
        event = args.shift
        before_save -> { ::Eventish.publish(event, self) }, *args
      end

      def around_save_event(*args)
        event = args.shift
        around_save ->(_object, block) { ::Eventish.publish(event, self, block: block) }, *args
      end

      def after_save_event(*args)
        event = args.shift
        after_save -> { ::Eventish.publish(event, self) }, *args
      end

      # Destroy events
      def before_destroy_event(*args)
        event = args.shift
        before_destroy -> { ::Eventish.publish(event, self) }, *args
      end

      def around_destroy_event(*args)
        event = args.shift
        around_destroy ->(_object, block) { ::Eventish.publish(event, self, block: block) }, *args
      end

      def after_destroy_event(*args)
        event = args.shift
        after_destroy -> { ::Eventish.publish(event, self) }, *args
      end

      # Commit events
      def after_commit_event(*args)
        event = args.shift
        after_commit -> { ::Eventish.publish(event, self) }, *args
      end

      def after_create_commit_event(*args)
        event = args.shift
        after_create_commit -> { ::Eventish.publish(event, self) }, *args
      end

      def after_update_commit_event(*args)
        event = args.shift
        after_update_commit -> { ::Eventish.publish(event, self) }, *args
      end

      def after_save_commit_event(*args)
        event = args.shift
        after_save_commit -> { ::Eventish.publish(event, self) }, *args
      end

      def after_destroy_commit_event(*args)
        event = args.shift
        after_destroy_commit -> { ::Eventish.publish(event, self) }, *args
      end

      def after_rollback_event(*args)
        event = args.shift
        after_rollback -> { ::Eventish.publish(event, self) }, *args
      end

      # Touch events
      def after_touch_event(*args)
        event = args.shift
        after_touch -> { ::Eventish.publish(event, self) }, *args
      end
    end
  end
end
