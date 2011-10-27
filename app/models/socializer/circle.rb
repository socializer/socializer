module Socializer
  class Circle < ActiveRecord::Base
    include Socializer::EmbeddedObjectBase
    
    attr_accessible :name, :description
    
    has_many   :ties
    has_many   :embedded_contacts, :through => :ties
    
    def contacts
      embedded_contacts.map { |ec| ec.embeddable }
    end
    
    def add_contact (contact_id)
      @tie = ties.build(:contact_id => contact_id)
      @tie.save
    end
    
    def remove_contact (contact_id)
      @tie = ties.find_by_contact_id(contact_id)
      @tie.destroy  
    end
    
  end
end
