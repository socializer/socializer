#
# Namespace for the Socializer engine
#
module Socializer
  class NotificationsController < ApplicationController
    before_action :authenticate_user!
    after_action :reset_unread_notifications, only: [:index]

    def index
      @notifications = current_user.received_notifications.decorate
    end

    def show
      notification = Notification.find_by(id: params[:id])
      notification.read! if notification.unread?
      redirect_to stream_path(provider: :activities, id: n.activity.id)
    end

    private

    def reset_unread_notifications
      return unless current_user.activity_object.unread_notifications_count > 0
      current_user.activity_object.unread_notifications_count = 0
      current_user.activity_object.save!
    end
  end
end
