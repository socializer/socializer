module Socializer
  class Audience < ActiveRecord::Base
    
    belongs_to :activity,        :class_name => 'Activity',       :foreign_key => 'activity_id'
    belongs_to :embedded_object, :class_name => 'EmbeddedObject', :foreign_key => 'object_id'
    
    def object
      embedded_object.embeddable
    end
    
    validates_inclusion_of :scope, :in => %w( PUBLIC CIRCLES LIMITED )
    
  end
end
