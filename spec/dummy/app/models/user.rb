# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :balances, dependent: :destroy

  before_validation -> { ::Eventish.publish('user_before_validation', self) }

  after_commit -> { ::Eventish.publish('user_after_commit', self) }
  after_save_commit -> { ::Eventish.publish('user_after_save_commit', self) }
end
