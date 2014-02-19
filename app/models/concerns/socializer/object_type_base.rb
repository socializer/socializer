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

      Activity.create! do |a|
        a.target_id          = activity_target_id if activity_target_id.present?
        a.actor_id           = author_id
        a.activity_object_id = guid
        a.verb               = Verb.find_or_create_by(name: activity_verb)

        a.add_audience(object_ids)
      end
    end
  end
end
