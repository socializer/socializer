require 'active_support/concern'

module Socializer
  module ObjectTypeBase
    extend ActiveSupport::Concern

    included do

      attr_accessor   :activity_verb, :scope, :object_ids, :activity_target_id
      attr_accessible :activity_verb, :scope, :object_ids, :author_id, :activity_target_id

      has_one :activity_object, as: :activitable, dependent: :destroy

      before_create :create_activity_object
      after_create :append_to_activity_stream

    end

    def guid
      activity_object.id
    end


    protected

    def create_activity_object
      build_activity_object
    end

    def append_to_activity_stream
      if activity_verb.present?
        activity = Activity.create! do |a|
          a.target_id          = activity_target_id if activity_target_id.present?
          a.actor_id           = author_id
          a.activity_object_id = guid
          a.verb               = Verb.find_or_create_by(name: activity_verb)
        end

        if object_ids.present?
          public = Socializer::Audience.privacy_level.find_value(:public).value.to_s
          circles = Socializer::Audience.privacy_level.find_value(:circles).value.to_s

          object_ids.each do |object_id|
            if object_id == public || object_id == circles
              Audience.create!(privacy_level: object_id, activity_id: activity.id)
            else
              Audience.create! do |a|
                a.activity_id = activity.id
                a.privacy_level = :limited
                a.activity_object_id = object_id
              end
            end
          end
        end
      end
    end
  end
end
