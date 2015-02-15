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
      fail(ArgumentError, "activity must be an instance of 'Socializer:Activity' not '#{activity.class.name}'") unless activity.is_a?(Socializer::Activity)

      @activity = activity
    end

    # Class Methods

    def self.perform(activity:)
      ActivityAudienceList.new(activity: activity).perform
    end

    # Instance Methods

    # [perform description]
    #
    # @return [Array]
    def perform
      list = []

      @activity.audiences.each do |audience|
        return [I18n.t('socializer.activities.audiences.index.tooltip.public')] if audience.public?
        list.concat(audience_list(audience))
      end

      list.unshift(@activity.activitable_actor.activitable.display_name)
    end

    private

    def audience_list(audience)
      return circles_audience_list if audience.circles?

      limited_audience_list(activitable: audience.activity_object.activitable) if audience.limited?
    end

    def circles_audience_list
      # byebug
      # TODO: Use a query if possible
      list = []

      @activity.actor.circles.each do |circle|
        list.concat(circle.activity_contacts)
      #   # circle.activity_contacts.each do |contact|
      #   #   @object_ids << contact
      #   # end
      end

      list
    end

    # In the case of LIMITED audience, then go through all the audience
    # circles and add contacts from those circles in the list of allowed
    # audience.
    def limited_audience_list(activitable:)
      # The target audience is either a group or a person,
      # which means we can add it as it is in the audience list.
      return [activitable.display_name] unless activitable.is_a?(Circle)

      subquery = activitable.activity_contacts.pluck(:activitable_id)
      Person.where(id: subquery).pluck(:display_name)
    end
  end
end
