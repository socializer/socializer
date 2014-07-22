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
        activity.add_audience(object_ids) if object_ids.present?
      end

      OpenStruct.new(activity: object, success?: object.persisted?)
    end
  end
end
