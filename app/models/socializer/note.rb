module Socializer
  class Note < ActiveRecord::Base
    include Socializer::EmbeddedObjectBase
    
    attr_accessible :content
    
    belongs_to :embedded_author, :class_name => 'EmbeddedObject', :foreign_key => 'author_id'
    
    def author
      embedded_author.embeddable
    end
    
  end
end
