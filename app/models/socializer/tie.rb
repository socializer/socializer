module Socializer
  class Tie < ActiveRecord::Base
    
    belongs_to :circle
    belongs_to :embedded_contact, :class_name => 'EmbeddedObject', :foreign_key => 'contact_id'
     
    def contact
      embedded_contact.embeddable
    end
    
  end
end
