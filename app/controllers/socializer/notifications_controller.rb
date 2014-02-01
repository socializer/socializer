module Socializer
  class NotificationsController < ApplicationController
    after_filter :reset_unread_notifications, only: [:index]

    def index
      @notifications = current_user.received_notifications
    end

    def show
      n = Notification.find(params[:id])
      read_notification(n) unless n.read?
      redirect_to stream_path(provider: :activities, id: n.activity.id)
    end

    private

    def read_notification(notification)
      notification.read = true
      notification.save!
    end

    def reset_unread_notifications
      if current_user.activity_object.unread_notifications_count > 0
        current_user.activity_object.unread_notifications_count = 0
        current_user.activity_object.save!
      end
    end

  end
end
