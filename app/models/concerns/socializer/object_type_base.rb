module Socializer
  module ObjectTypeBase
    extend ActiveSupport::Concern

    included do
      attr_accessor   :activity_verb, :scope, :object_ids, :activity_target_id
      attr_accessible :activity_verb, :scope, :object_ids, :author_id, :activity_target_id

      has_one :activity_object, as: :activitable, dependent: :destroy

      before_create :activity_object_builder
      after_create  :append_to_activity_stream

    end

    def guid
      activity_object.id
    end

    protected

    def activity_object_builder
      build_activity_object
    end

    def append_to_activity_stream
      # REFACTOR: remove the after_create callback
      #           the `return if activity_verb.blank?` guard is needed to block the create! method when
      #           creating shares, likes, unlikes, etc

      return if activity_verb.blank?

      ActivityCreator.create!(actor_id: author_id,
                              activity_object_id: guid,
                              target_id: activity_target_id,
                              verb: activity_verb,
                              object_ids: object_ids)
      # return if activity_verb.blank?
      #
      # Activity.create! do |a|
      #   a.target_id          = activity_target_id if activity_target_id.present?
      #   a.actor_id           = author_id
      #   a.activity_object_id = guid
      #   a.verb               = Verb.find_or_create_by(name: activity_verb)
      #
      #   a.add_audience(object_ids) if object_ids.present?
      # end
    end
  end
end
