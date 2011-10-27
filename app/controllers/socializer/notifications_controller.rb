module Socializer
  class NotificationsController < ApplicationController
    
    def index
      @notifications = current_user.received_notifications
    end
  
  end
end
