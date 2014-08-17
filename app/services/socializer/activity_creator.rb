#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Service object for creating and Socializer::Activity
  #
  class ActivityCreator
    include ActiveModel::Model

    attr_accessor :actor_id, :activity_object_id, :target_id, :verb, :object_ids, :content

    # Validations
    validates :actor_id, presence: true
    validates :activity_object_id, presence: true
    validates :verb, presence: true

    # Instance Methods

    # Creates an activity, adds the content and audience if needed.
    #
    # @return [OpenStruct]
    def perform
      fail(RecordInvalid, "Validation failed: #{errors.full_messages.to_sentence}") unless valid?
      create_activity
    end

    private

    # Add an audience to the activity
    #
    # @param activity: [Socializer::Activity] The activity to add the audience to
    # @param object_ids [Array<Integer>] List of audiences to target
    def add_audience_to_activity(activity:, audience_ids:)
      audience_ids = audience_ids.split(',') if %w(Fixnum String).include?(audience_ids.class.name)
      limited      = Audience.privacy_value(privacy: :limited)
      not_limited  = %W(#{Audience.privacy_value(privacy: :public)} #{Audience.privacy_value(privacy: :circles)})

      audience_ids.each do |audience_id|
        privacy  = not_limited.include?(audience_id) ? audience_id : limited
        audience = activity.audiences.build(privacy: privacy)
        audience.activity_object_id = audience_id if privacy == limited
      end
    end

    def create_activity
      object = Activity.create! do |activity|
        activity.actor_id           = actor_id
        activity.activity_object_id = activity_object_id
        activity.target_id          = target_id if target_id.present?
        activity.verb               = Verb.find_or_create_by(display_name: verb)

        activity.build_activity_field(content: content) if content.present?
        add_audience_to_activity(activity: activity, audience_ids: object_ids) if object_ids.present?
      end

      # TODO: Do we need this? what returns if create fails? Add tests
      OpenStruct.new(activity: object, success?: object.persisted?)
    end
  end
end
