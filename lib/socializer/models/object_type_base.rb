require 'active_support/concern'

module Socializer
  module ObjectTypeBase
    extend ActiveSupport::Concern

    included do

      attr_accessor   :activity_verb, :scope, :object_ids, :activity_target_id
      attr_accessible :activity_verb, :scope, :object_ids, :author_id, :activity_target_id

      has_one :activity_object, :as => :activitable, :dependent => :destroy

      before_create :create_activity_object
      after_create :append_to_activity_stream

    end

    def guid
      activity_object.id
    end


    protected

    def create_activity_object
      build_activity_object
      # ActivityObject.create!(:activitable_id => self.id, :activitable_type => self.class.to_s)
    end

    def append_to_activity_stream

      if activity_verb.present?

        activity           = Activity.new
        activity.target_id = activity_target_id if activity_target_id.present?
        activity.actor_id  = author_id
        activity.object_id = guid
        activity.verb      = Verb.find_or_create_by(name: activity_verb)
        activity.save!

        if object_ids.present?
          object_ids.each do |object_id|
            public = Socializer::Audience.privacy_level.find_value(:public).value.to_s
            circles = Socializer::Audience.privacy_level.find_value(:circles).value.to_s

            if object_id == public || object_id == circles
              audience               = Audience.new
              audience.activity_id   = activity.id
              audience.privacy_level = object_id
              audience.save!
            else
              audience               = Audience.new
              audience.activity_id   = activity.id
              audience.privacy_level = :limited
              audience.object_id     = object_id
              audience.save!
            end
          end
        end

      end

    end

  end
end
