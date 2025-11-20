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
    # @param activity [Socializer::Activity] the activity to build the
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
    # @param activity [Socializer::Activity] the activity to build the
    #   audience for
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

    # Returns an array of display names for the given `audience`.
    # - For circle audiences this delegates to `circles_audience_list`.
    # - For limited audiences this delegates to `limited_audience_list`.
    # - For other audience types it returns `nil`.
    #
    # @param audience [Socializer::Audience] the audience to build the list for
    #
    # @return [Array<String>, nil] display names included in the audience or `nil`
    #
    # @example
    #   # Circle audience
    #   audience_list(audience: circle_audience) # => ["Alice", "Bob"]
    #   # Limited audience (person/group)
    #   audience_list(audience: limited_audience) # => ["John Doe"]
    def audience_list(audience:)
      return circles_audience_list if audience.circles?

      activitable = audience.activity_object.activitable

      limited_audience_list(activitable:) if audience.limited?
    end

    # Returns an array of display names for the circle audience.
    # Collects the actor's contacts and plucks their `display_name`
    # values for use in the activity tooltip list.
    #
    # @return [Array<String>] display names of contacts in the actor's circles
    #
    # @example
    #   # Given an activity whose actor has contacts:
    #   # activity.actor.contacts.pluck(:display_name) # => ["Alice", "Bob"]
    #   circles_audience_list
    #   # => ["Alice", "Bob"]
    def circles_audience_list
      @activity.actor.contacts.pluck(:display_name)
    end

    # Returns an array of display names for a LIMITED audience.
    # For non-Circle activitable objects (e.g. Person or Group), returns the
    # activitable's `display_name` wrapped in an Array. For Circle activitables,
    # returns the `display_name` of each contact in the circle.
    #
    # @param activitable [Object] the audience target (Circle, Group or Person)
    #
    # @return [Array<String>] display names included in the limited audience
    #
    # @example
    #   # Person or Group
    #   limited_audience_list(activitable: person) # => ["John Doe"]
    #   # Circle
    #   limited_audience_list(activitable: circle) # => ["Alice", "Bob"]
    def limited_audience_list(activitable:)
      # The target audience is either a group or a person,
      # which means we can add it as it is in the audience list.
      return [activitable.display_name] unless activitable.is_a?(Circle)

      activitable.contacts.pluck(:display_name)
    end
  end
end
