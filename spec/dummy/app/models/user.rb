# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :balances, dependent: :destroy

  before_validation ::Eventish::Callback
  after_save_commit ::Eventish::Callback
end
