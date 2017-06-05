# frozen_string_literal: true

require "dry-initializer"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Prepares the list to display in the tooltip
  #
  class ActivityAudienceList
    # Initializer
    #
    extend Dry::Initializer

    # Adds the activity keyword argument to the initializer, ensures the tyoe
    # is [Socializer::Activity], and creates a private reader
    option :activity, Dry::Types["any"].constrained(type: Activity),
           reader: :private

    # Class Methods

    # Invoke the ActivityAudienceList. This is the primary public API method.
    #
    # @param activity: [Socializer::Activity] the activity to build the
    # audience for
    #
    # @return [Array]
    def self.call(activity:)
      new(activity: activity).call
    end

    # Instance Methods

    # Invoke the ActivityAudienceList instance. This is the primary public
    # API method.
    #
    # @return [Array]
    def call
      list = []

      activity.audiences.each do |audience|
        if audience.public?
          message = I18n.t("tooltip.public",
                           scope: "socializer.activities.audiences.index")
          return [message]
        end

        list.concat(audience_list(audience: audience))
      end

      list.unshift(activity.activitable_actor.activitable.display_name)
    end

    private

    def audience_list(audience:)
      return circles_audience_list if audience.circles?

      activitable = audience.activity_object.activitable

      limited_audience_list(activitable: activitable) if audience.limited?
    end

    def circles_audience_list
      activity.actor.contacts.pluck(:display_name)
    end

    # In the case of LIMITED audience, then go through all the audience
    # circles and add contacts from those circles in the list of allowed
    # audience.
    def limited_audience_list(activitable:)
      # The target audience is either a group or a person,
      # which means we can add it as it is in the audience list.
      return [activitable.display_name] unless activitable.is_a?(Circle)

      activitable.contacts.pluck(:display_name)
    end
  end
end
