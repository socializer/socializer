require 'active_support/concern'

module Socializer
  module Object
    extend ActiveSupport::Concern

    included do

      attr_accessor   :activity_verb, :scope, :object_ids, :activity_parent_id
      attr_accessible :activity_verb, :scope, :object_ids, :author_id, :activity_parent_id

      has_one :embedded_object, :as => :embeddable, :dependent => :destroy

      before_create :create_embedded_object
      after_create :append_to_activity_stream

    end

    def guid
      embedded_object.id
    end


    protected

    def create_embedded_object
      build_embedded_object
      # EmbeddedObject.create!(:embeddable_id => self.id, :embeddable_type => self.class.to_s)
    end

    def append_to_activity_stream

      if activity_verb.present?

        activity           = Activity.new
        activity.parent_id = activity_parent_id if activity_parent_id.present?
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
