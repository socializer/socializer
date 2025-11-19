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
    #     helpers.tag.span(class: 'time') do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end
    #

    # Returns the CSS class for the notification card based on its index and read status.
    #
    # @param index [Integer] the index of the item in the enumeration
    #
    # @return [String] the CSS class for the notification card
    #
    # @example
    #   card_class(index: 1) #=> "panel-success bg-success"
    def card_class(index:)
      classname = "panel-default"
      classname = "panel-default bg-muted" if model.read

      classname = "panel-success bg-success" if index <= unread_notifications_count

      classname
    end

    private

    # Returns the number of unread notifications for the current user's activity object.
    #
    # @return [Integer] the unread notification count (0 when none)
    #
    # @example
    #   unread_notifications_count #=> 3
    def unread_notifications_count
      helpers.current_user.activity_object.unread_notifications_count
    end
  end
end
