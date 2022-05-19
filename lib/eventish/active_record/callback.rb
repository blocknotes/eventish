# frozen_string_literal: true

module Eventish
  module ActiveRecord
    module Callback
      # Init events
      def after_initialize_event
        before_validation -> { ::Eventish.publish(event, self) }
      end

      def after_find_event
        before_validation -> { ::Eventish.publish(event, self) }
      end

      # Validation events
      def before_validation_event(event)
        before_validation -> { ::Eventish.publish(event, self) }
      end

      def after_validation_event(event)
        after_validation -> { ::Eventish.publish(event, self) }
      end

      # Create events
      def before_create_event(event)
        before_create -> { ::Eventish.publish(event, self) }
      end

      def around_create_event(event)
        around_create -> { ::Eventish.publish(event, self) }
      end

      def after_create_event(event)
        after_create -> { ::Eventish.publish(event, self) }
      end

      # Update events
      def before_update_event(event)
        before_update -> { ::Eventish.publish(event, self) }
      end

      def around_update_event(event)
        around_update -> { ::Eventish.publish(event, self) }
      end

      def after_update_event(event)
        after_update -> { ::Eventish.publish(event, self) }
      end

      # Save events
      def before_save_event(event)
        before_save -> { ::Eventish.publish(event, self) }
      end

      def around_save_event(event)
        around_save -> { ::Eventish.publish(event, self) }
      end

      def after_save_event(event)
        after_save -> { ::Eventish.publish(event, self) }
      end

      # Destroy events
      def before_destroy_event(event)
        before_destroy -> { ::Eventish.publish(event, self) }
      end

      def around_destroy_event(event)
        around_destroy -> { ::Eventish.publish(event, self) }
      end

      def after_destroy_event(event)
        after_destroy -> { ::Eventish.publish(event, self) }
      end

      # Commit events
      def after_commit_event(event)
        after_commit -> { ::Eventish.publish(event, self) }
      end

      def after_save_commit_event(event)
        after_save_commit -> { ::Eventish.publish(event, self) }
      end

      def after_create_commit_event(event)
        after_create_commit -> { ::Eventish.publish(event, self) }
      end

      def after_update_commit_event(event)
        after_update_commit -> { ::Eventish.publish(event, self) }
      end

      def after_destroy_commit_event(event)
        after_destroy_commit -> { ::Eventish.publish(event, self) }
      end

      def after_rollback_event(event)
        after_rollback -> { ::Eventish.publish(event, self) }
      end

      # Touch events
      def after_touch_event(event)
        after_touch -> { ::Eventish.publish(event, self) }
      end
    end
  end
end
