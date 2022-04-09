# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Service object for creating a Socializer::Activity
  #
  class CreateActivity
    include ActiveModel::Model
    include Utilities::Message

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

    def activity_field
      ActivityField.new(content:) if content.present?
    end

    def activity_attributes
      {
        actor_id:,
        activity_object_id:,
        target_id:,
        verb: Verb.find_or_create_by(display_name: verb)
      }
    end

    # Add an audience to the activity
    #
    # @param activity: [Socializer::Activity] The activity to add the audience
    # to
    def add_audience_to_activity(activity:)
      object_ids_array.each do |audience_id|
        privacy  = audience_privacy(audience_id:)
        audience = activity.audiences.build(privacy:)

        audience.activity_object_id = audience_id if privacy == limited_privacy
      end
    end

    def object_ids_array
      if Set.new(%w[Integer String]).include?(object_ids.class.name)
        return object_ids.split(",")
      end

      object_ids
    end

    def audience_privacy(audience_id:)
      not_limited = Set.new(%W[#{public_privacy} #{circles_privacy}])

      @audience_privacy ||= if not_limited.include?(audience_id)
                              audience_id
                            else
                              limited_privacy
                            end
    end

    def circles_privacy
      @circles_privacy ||= Audience.privacy.circles.value
    end

    def limited_privacy
      @limited_privacy ||= Audience.privacy.limited.value
    end

    def public_privacy
      @public_privacy ||= Audience.privacy.public.value
    end

    def create_activity
      Activity.create(activity_attributes) do |activity|
        activity.activity_field = activity_field

        add_audience_to_activity(activity:) if object_ids.present?
      end
    end
  end
end
