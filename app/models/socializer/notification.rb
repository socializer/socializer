module Socializer
  class Notification < ActiveRecord::Base
    # Increment the number of unread notifications
    after_save { activity_object.increment_unread_notifications_count }

    attr_accessible :read

    # Relationships
    belongs_to :activity
    belongs_to :activity_object # Person, Group, ...

    # Validations
    validates_presence_of :activity_id
    validates_presence_of :activity_object_id
  end
end
