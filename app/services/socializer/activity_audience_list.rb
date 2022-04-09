# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Prepares the list to display in the tooltip
  #
  class ActivityAudienceList
    include ActiveModel::Model
    include Utilities::Message

    attr_reader :activity

    validates :activity, presence: true, type: Socializer::Activity

    # Initializer
    #
    # @param activity: [Socializer::Activity] the activity to build the
    # audience for
    #
    # @return [Socializer::ActivityAudienceList] returns an instance of
    # ActivityAudienceList
    def initialize(activity:)
      @activity = activity

      raise(ArgumentError, errors.full_messages.to_sentence) unless valid?
    end

    # Class Methods

    # Invoke the ActivityAudienceList. This is the primary public API method.
    #
    # @param activity: [Socializer::Activity] the activity to build the
    # audience for
    #
    # @return [Array]
    def self.call(activity:)
      new(activity:).call
    end

    # Instance Methods

    # Invoke the ActivityAudienceList instance. This is the primary public
    # API method.
    #
    # @return [Array]
    def call
      list = []

      @activity.audiences.each do |audience|
        if audience.public?
          message = I18n.t("tooltip.public",
                           scope: "socializer.activities.audiences.index")
          return [message]
        end

        list.concat(audience_list(audience:))
      end

      list.unshift(@activity.activitable_actor.activitable.display_name)
    end

    private

    def audience_list(audience:)
      return circles_audience_list if audience.circles?

      activitable = audience.activity_object.activitable

      limited_audience_list(activitable:) if audience.limited?
    end

    def circles_audience_list
      @activity.actor.contacts.pluck(:display_name)
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
