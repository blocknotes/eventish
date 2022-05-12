# frozen_string_literal: true

module Eventish
  class Callback
    class << self
      def callback_event(target, &block)
        event = "#{Eventish.underscore(target.class.to_s)}_#{__callee__}"
        Eventish.adapter.publish(event, target, &block)
      end

      def callback_commit_event(target, &block)
        event = "#{Eventish.underscore(target.class.to_s)}_after_commit"
        Eventish.adapter.publish(event, target, &block)
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
