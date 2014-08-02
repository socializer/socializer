#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Service object for creating and Socializer::Activity
  #
  class ActivityCreator
    # Creates an activity, adds the content and audience if needed.
    #
    # @param actor_id [Integer]
    # @param activity_object_id [Integer]
    # @param target_id [Integer]
    # @param verb [String] Verb for the activity
    # @param object_ids [Array<Integer>] List of audiences to target
    # @param content [String] Text with the share
    #
    # @return [OpenStruct]
    def self.create!(actor_id:, activity_object_id:, target_id: nil, verb:, object_ids: nil, content: nil)
      object = Activity.create! do |activity|
        activity.actor_id           = actor_id
        activity.activity_object_id = activity_object_id
        activity.target_id          = target_id if target_id.present?
        activity.verb               = Verb.find_or_create_by(display_name: verb)

        activity.build_activity_field(content: content) if content.present?
        add_audience_to_activity(activity: activity, audience_ids: object_ids) if object_ids.present?
      end

      OpenStruct.new(activity: object, success?: object.persisted?)
    end

    # Add an audience to the activity
    #
    # @param activity: [Socializer::Activity] The activity to add the audience to
    # @param object_ids [Array<Integer>] List of audiences to target
    def self.add_audience_to_activity(activity:, audience_ids:)
      audience_ids = audience_ids.split(',') if %w(Fixnum String).include?(audience_ids.class.name)
      privacy      = Audience.privacy
      limited      = Audience.privacy_value(privacy: :limited)
      not_limited  = %W(#{Audience.privacy_value(privacy: :public)} #{Audience.privacy_value(privacy: :circles)})

      audience_ids.each do |audience_id|
        privacy  = not_limited.include?(audience_id) ? audience_id : limited
        audience = activity.audiences.build(privacy: privacy)
        audience.activity_object_id = audience_id if privacy == limited
      end
    end
  end
end
