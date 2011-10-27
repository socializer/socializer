module Socializer
  class Membership < ActiveRecord::Base
    
    belongs_to :group
    belongs_to :embedded_member, :class_name => 'EmbeddedObject', :foreign_key => 'member_id'
    
    def member
      embedded_member.embeddable
    end
    
    def approve!
      self.update_attribute(:active, true)
    end
    
    def confirm!
      self.update_attribute(:active, true)
    end
    
  end
end
