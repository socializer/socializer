module Socializer
  module NoteConcern
    extend ActiveSupport::Concern

    included do
      after_create :create_notifications
    end

    def create_notifications
      activity = Activity.find_by(activity_object_id: guid)
      Notification.create_for_activity(activity)
    end

  end
end
