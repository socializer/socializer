module Socializer
  class NotificationsController < ApplicationController
    after_filter :set_displayed, only: [:index]

    def index
      @notifications = current_user.received_notifications
    end

    def show
      n = Notification.find(params[:id])
      n.read = true
      n.save!
      # TODO : Need to redirect to the activity
      redirect_to stream_show_path(n.activity)
    end

    private

    def set_displayed
      @notifications.each do |n|
        n.displayed = true;
        n.save!
      end
    end
  end
end
