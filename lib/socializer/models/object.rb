require 'active_support/concern'

module Socializer  
  module Object
    extend ActiveSupport::Concern

    included do

      has_one :embedded_object, :as => :embeddable, :dependent => :destroy
      
      attr_accessor   :activity_verb, :scope, :object_ids, :activity_parent_id
      attr_accessible :activity_verb, :scope, :object_ids, :author_id, :activity_parent_id
      
      before_create  :create_embedded_object
      after_create   :append_to_activity_stream

    end
    
    def guid
      embedded_object.id
    end
    
    def create_embedded_object
      EmbeddedObject.create!(:embeddable_id => self.id, :embeddable_type => self.class.to_s)
    end
    
    def append_to_activity_stream
      
      unless activity_verb.nil?
        
        activity           = Activity.new     
        activity.parent_id = activity_parent_id unless activity_parent_id.nil?          
        activity.actor_id  = author_id
        activity.object_id = guid
        activity.verb      = activity_verb
        activity.save!
        
        unless object_ids.nil?
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