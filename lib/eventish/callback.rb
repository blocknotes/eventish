# frozen_string_literal: true

module Eventish
  class Callback
    class << self
      def publish(event_name, target, options: {})
        ::ActiveSupport::Notifications.instrument(event_name, target: target, event_options: options)
      end

      def subscribe(event_name, handler)
        ::ActiveSupport::Notifications.subscribe(event_name) do |name, start, finish, id, payload|
          args = { event: name, id: id, start: start, finish: finish }
          if handler < AsyncEvent
            handler.perform_later(payload[:target], args)
          else
            handler.call(payload[:target], args, &payload[:block])
          end
        end
      end

      # --- Callbacks -----------------------------------------------------------
      def callback_event(target, &block)
        event = "#{target.class.to_s.underscore}_#{__callee__}"
        ::ActiveSupport::Notifications.instrument(event, target: target, block: block)
      end

      def callback_commit_event(target, &block)
        event = "#{target.class.to_s.underscore}_after_commit"
        ::ActiveSupport::Notifications.instrument(event, target: target, block: block)
      end

      alias_method :after_initialize, :callback_event
      alias_method :after_find, :callback_event

      alias_method :before_validation, :callback_event
      alias_method :after_validation, :callback_event

      alias_method :before_create, :callback_event
      alias_method :around_create, :callback_event
      alias_method :after_create, :callback_event

      alias_method :before_update, :callback_event
      alias_method :around_update, :callback_event
      alias_method :after_update, :callback_event

      alias_method :before_save, :callback_event
      alias_method :around_save, :callback_event
      alias_method :after_save, :callback_event

      alias_method :before_destroy, :callback_event
      alias_method :around_destroy, :callback_event
      alias_method :after_destroy, :callback_event

      alias_method :after_commit, :callback_commit_event
      alias_method :after_save_commit, :callback_commit_event # => after_commit
      alias_method :after_create_commit, :callback_commit_event # => after_commit
      alias_method :after_update_commit, :callback_commit_event # => after_commit
      alias_method :after_destroy_commit, :callback_commit_event # => after_commit
      alias_method :after_rollback, :callback_event

      alias_method :after_touch, :callback_event
    end
  end
end
