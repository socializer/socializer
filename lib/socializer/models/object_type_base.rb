require 'active_support/concern'

module Socializer
  module ObjectTypeBase
    extend ActiveSupport::Concern

    included do

      attr_accessor   :activity_verb, :scope, :object_ids, :activity_target_id
      attr_accessible :activity_verb, :scope, :object_ids, :author_id, :activity_target_id

      # TODO: Rename the embeddable polymorphic relationship
      has_one :activity_object, :as => :embeddable, :dependent => :destroy

      before_create :create_activity_object
      after_create :append_to_activity_stream

    end

    def guid
      activity_object.id
    end


    protected

    def create_activity_object
      build_activity_object
      # ActivityObject.create!(:embeddable_id => self.id, :embeddable_type => self.class.to_s)
    end

    def append_to_activity_stream

      if activity_verb.present?

        activity           = Activity.new
        activity.target_id = activity_target_id if activity_target_id.present?
        activity.actor_id  = author_id
        activity.object_id = guid
        activity.verb      = activity_verb
        activity.save!

        if object_ids.present?
          object_ids.each do |object_id|
            if object_id == 'PUBLIC' || object_id == 'CIRCLES'
              audience             = Audience.new
              audience.activity_id = activity.id
              audience.scope       = object_id
              audience.save!
            else
              audience             = Audience.new
              audience.activity_id = activity.id
              audience.scope       = 'LIMITED'
              audience.object_id   = object_id
              audience.save!
            end
          end
        end

      end

    end

  end
end
