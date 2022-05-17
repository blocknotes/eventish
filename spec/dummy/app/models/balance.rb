# frozen_string_literal: true

class Balance < ActiveRecord::Base
  belongs_to :user

  around_create -> { ::Eventish.publish('balance_around_create', self) }
end
