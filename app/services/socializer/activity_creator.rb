#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Service object for creating a Socializer::Activity
  #
  class ActivityCreator
    include ActiveModel::Model

    attr_accessor :actor_id, :activity_object_id, :target_id, :verb,
                  :object_ids, :content

    # Validations
    validates :actor_id, presence: true
    validates :activity_object_id, presence: true
    validates :verb, presence: true

    # Instance Methods

    # Invoke the ActivityCreator. This is the primary public API method.
    # Creates an activity, adds the content and audience if needed.
    #
    # @return [Socializer::Activity]
    def call
      return create_activity if valid?

      message = I18n.t("activerecord.errors.messages.record_invalid",
                       errors: errors.full_messages.to_sentence)

      raise(Errors::RecordInvalid, message)
    end

    private

    # Add an audience to the activity
    #
    # @param activity: [Socializer::Activity] The activity to add the audience
    # to
    # @param audience_ids [Array<Integer>] List of audiences to target
    def add_audience_to_activity(activity:, audience_ids:)
      if %w(Fixnum String).include?(audience_ids.class.name)
        audience_ids = audience_ids.split(",")
      end

      audience_ids.each do |audience_id|
        privacy  = audience_privacy(audience_id: audience_id)
        audience = activity.audiences.build(privacy: privacy)

        audience.activity_object_id = audience_id if privacy == limited_privacy
      end
    end

    def audience_privacy(audience_id:)
      not_limited = %W(#{public_privacy} #{circles_privacy})

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
      Activity.create! do |activity|
        activity.actor_id           = actor_id
        activity.activity_object_id = activity_object_id
        activity.target_id          = target_id if target_id.present?
        activity.verb               = Verb.find_or_create_by(display_name: verb)

        activity.build_activity_field(content: content) if content.present?

        if object_ids.present?
          add_audience_to_activity(activity: activity, audience_ids: object_ids)
        end
      end
    end
  end
end
