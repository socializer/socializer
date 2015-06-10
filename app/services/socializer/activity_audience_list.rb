#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Prepares the list to diplay in the tooltip
  #
  class ActivityAudienceList
    # Initializer
    #
    # @param activity: [Socializer:Activity] the activity to build the audience for
    #
    # @return [Socializer:ActivityAudienceList] returns an instance of ActivityAudienceList
    def initialize(activity:)
      unless activity.is_a?(Socializer::Activity)
        message = I18n.t('socializer.errors.messages.wrong_instance_type', argument: 'activity', valid_class: Activity.name, invalid_class: activity.class.name)
        fail(ArgumentError, message)
      end

      @activity = activity
    end

    # Class Methods

    # Invoke the ActivityAudienceList. This is the primary public API method.
    #
    # @param activity: [Socializer::Activity] the activity to build the audience for
    #
    # @return [Array]
    def self.perform(activity:)
      ActivityAudienceList.new(activity: activity).perform
    end

    # Instance Methods

    # Invoke the ActivityAudienceList instance. This is the primary public API method.
    #
    # @return [Array]
    def perform
      list = []

      @activity.audiences.each do |audience|
        return [I18n.t('socializer.activities.audiences.index.tooltip.public')] if audience.public?
        list.concat(audience_list(audience: audience))
      end

      list.unshift(@activity.activitable_actor.activitable.display_name)
    end

    private

    def audience_list(audience:)
      return circles_audience_list if audience.circles?

      limited_audience_list(activitable: audience.activity_object.activitable) if audience.limited?
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
