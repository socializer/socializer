module Socializer
  module ObjectTypeBase
    extend ActiveSupport::Concern

    included do
      attr_accessor   :activity_verb, :scope, :object_ids, :activity_target_id
      attr_accessible :activity_verb, :scope, :object_ids, :author_id, :activity_target_id

      has_one :activity_object, as: :activitable, dependent: :destroy

      before_create :create_activity_object
      after_create  :append_to_activity_stream

    end

    def guid
      activity_object.id
    end

    protected

    def create_activity_object
      build_activity_object
    end

    def append_to_activity_stream
      # REFACTOR: the activity_verb.blank? and object_ids.blank? checks shouldn't be needed
      #           since the record should be invalid without them.
      return if activity_verb.blank? || object_ids.blank?

      activity = Activity.new do |a|
        a.target_id          = activity_target_id if activity_target_id.present?
        a.actor_id           = author_id
        a.activity_object_id = guid
        a.verb               = Verb.find_or_create_by(name: activity_verb)
      end

      add_audience_to_activity(activity, object_ids)

      activity.save!
    end

    # Add audience to activity
    # @param activity [Activity] Activity to add the audience
    # @param object_ids [Array<Integer>] List of audiences to target
    def add_audience_to_activity(activity, object_ids)
      public  = Socializer::Audience.privacy_level.find_value(:public).value.to_s
      circles = Socializer::Audience.privacy_level.find_value(:circles).value.to_s

      # REFACTOR: remove duplication
      object_ids.each do |object_id|
        if object_id == public || object_id == circles
          activity.audiences.build(privacy_level: object_id)
        else
          activity.audiences.build do |a|
            a.privacy_level = :limited
            a.activity_object_id = object_id
          end
        end
      end # each
    end # add_audience_to_activity
  end
end
