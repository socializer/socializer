module Socializer
  class Comment < ActiveRecord::Base
    include Socializer::EmbeddedObjectBase
    
    attr_accessible :object_id, :content
    
    belongs_to :embedded_author,           :class_name => 'EmbeddedObject', :foreign_key => 'author_id'
    belongs_to :embedded_commented_object, :class_name => 'EmbeddedObject', :foreign_key => 'object_id'
    
    def author
      embedded_author.embeddable
    end
    
    def commented_object
      embedded_commented_object.embeddable
    end
    
  end
end
