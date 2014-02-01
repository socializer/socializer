module Socializer
  class Notification < ActiveRecord::Base
    # Increment the number of unread notifications
    after_save { activity_object.increment_unread_notifications_count }

    attr_accessible :read

    # Relationships
    belongs_to :activity
    belongs_to :activity_object # Person, Group, ...

    # Validations
    validates :activity_id, presence: true
    validates :activity_object_id, presence: true
  end
end
