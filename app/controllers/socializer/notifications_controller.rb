#
# Namespace for the Socializer engine
#
module Socializer
  class NotificationsController < ApplicationController
    before_action :authenticate_user
    # TODO: Does this need to be an after_action? Can reset_unread_notifications be called at the end of the index action?
    after_action :reset_unread_notifications, only: [:index]

    # GET /notifications
    def index
      @notifications = current_user.received_notifications.decorate
    end

    # GET /notifications/1
    def show
      notification = Notification.find_by(id: params[:id])
      notification.mark_as_read if notification.unread?

      redirect_to activity_activities_path(activity_id: notification.activity.id)
    end

    private

    def reset_unread_notifications
      activity_object = current_user.activity_object

      return unless activity_object.unread_notifications_count > 0
      activity_object.unread_notifications_count = 0
      activity_object.save!
    end
  end
end
