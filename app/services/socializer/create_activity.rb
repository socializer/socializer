# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Service object for creating a Socializer::Activity
  #
  class CreateActivity
    CIRCLES_PRIVACY = Socializer::Audience.privacy.circles.value.freeze
    LIMITED_PRIVACY = Socializer::Audience.privacy.limited.value.freeze
    PUBLIC_PRIVACY = Socializer::Audience.privacy.public.value.freeze

    include ActiveModel::Model

    attr_accessor :actor_id, :activity_object_id, :target_id, :verb,
                  :object_ids, :content

    # Validations
    validates :actor_id, presence: true
    validates :activity_object_id, presence: true
    validates :verb, presence: true

    # Instance Methods

    # Invoke the CreateActivity. This is the primary public API method.
    # Creates an activity, adds the content and audience if needed.
    #
    # @return [Socializer::Activity]
    def call
      create_activity
    end

    private

    def activity_attributes
      {
        actor_id: actor_id,
        activity_object_id: activity_object_id,
        target_id: target_id,
        verb: Verb.find_or_create_by(display_name: verb)
      }
    end

    # Add an audience to the activity
    #
    # @param activity: [Socializer::Activity] The activity to add the audience
    # to
    def add_audience_to_activity(activity:)
      object_ids_array.each do |audience_id|
        privacy  = audience_privacy(audience_id: audience_id)
        audience = activity.audiences.build(privacy: privacy)
        audience.activity_object_id = audience_id if privacy == LIMITED_PRIVACY
        audience.save
      end
    end

    def object_ids_array
      if Set.new(%w[Integer String]).include?(object_ids.class.name)
        return object_ids.split(",")
      end

      object_ids
    end

    def audience_privacy(audience_id:)
      not_limited = Set.new(%W[#{PUBLIC_PRIVACY} #{CIRCLES_PRIVACY}])

      return audience_id if not_limited.include?(audience_id)

      LIMITED_PRIVACY
    end

    def create_activity
      activity = Activity.none

      ActiveRecord::Base.transaction do
        activity = Activity.create(activity_attributes)
        activity.create_activity_field(content: content) if content.present?

        add_audience_to_activity(activity: activity) if object_ids.present?
      end

      activity
    end

    #
    # The verb to use when creating an [Socializer::ActivityObject]
    #
    # @param [String] name The display name for the verb
    #
    # @return [Socializer::Verb]
    #

    end
  end
end
