# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Notifications controller
  #
  class NotificationsController < ApplicationController
    before_action :authenticate_user

    # GET /notifications
    def index
      @notifications = current_user.received_notifications.decorate
      reset_unread_notifications
    end

    # GET /notifications/1
    def show
      notification = Notification.find_by(id: params[:id])
      activity     = notification.activity

      notification.mark_as_read if notification.unread?

      redirect_to activity_activities_path(activity_id: activity.id)
    end

    private

    def reset_unread_notifications
      current_user.activity_object.reset_unread_notifications
    end
  end
end
