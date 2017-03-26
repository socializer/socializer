# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators for {Socializer::Notification}
  class NotificationDecorator < ApplicationDecorator
    delegate_all

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: "time" do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end
    #

    # Return the CSS class for the notification
    #
    # @param index: [Integer] Index of the item in the enum
    #
    # @return [type] [description]
    def card_class(index:)
      classname = "panel-default"
      classname = "panel-default bg-muted" if model.read

      if index <= unread_notifications_count
        classname = "panel-success bg-success"
      end

      classname
    end

    private

    def unread_notifications_count
      helpers.current_user.activity_object.unread_notifications_count
    end
  end
end
