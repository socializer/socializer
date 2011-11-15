module Socializer
  class Person < ActiveRecord::Base
    include Socializer::EmbeddedObjectBase
    
    has_many :authentications
    
    attr_accessible :display_name, :email, :language
    
    def circles
      embedded_object.circles
    end
    
    def comments
      embedded_object.comments
    end
    
    def notes
      embedded_object.notes
    end
    
    def groups
      embedded_object.groups
    end
    
    def memberships
      embedded_object.memberships
    end
    
    def received_notifications
      raise "Method not implemented yet."
    end
    
    def contacts
      circles.map { |c| c.contacts }.flatten!.uniq! || []
    end
    
    def contact_of
      Circle.joins(:ties).where('socializer_ties.contact_id' => self.guid).map { |c| c.author }.uniq! || []
    end

    def likes
      likes = Activity.where(:actor_id => self.embedded_object.id, :verb => 'like')
      unlikes = Activity.where(:actor_id => self.embedded_object.id, :verb => 'unlike')
      return likes - unlikes
    end
    
    def likes? (object)
      likes = Activity.where(:object_id => object.id, :actor_id => self.embedded_object.id, :verb => 'like')
      if likes.count == 0
        return false
      else
        unlikes = Activity.where(:object_id => object.id, :actor_id => self.embedded_object.id, :verb => 'unlike')
        if likes.count == unlikes.count
          return false
        end
      end
      
      return true
    end
    
    def pending_memberships_invites
      memberships.where(:active => false).where(" ( SELECT COUNT(1) FROM socializer_groups WHERE socializer_groups.id = socializer_memberships.group_id AND socializer_groups.privacy_level = 'PRIVATE' ) > 0 ")
    end
    
    def self.create_with_omniauth(auth)
      create! do |user|
        if auth['user_info']
          user.display_name = auth['user_info']['name'] if auth['user_info']['name']
          user.email = auth['user_info']['email'] if auth['user_info']['email']
        end
        if auth['extra'] && auth['extra']['user_hash']
          user.display_name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name']
          user.email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email']
        end
        user.authentications.build(:provider => auth['provider'], :uid => auth['uid'])
      end
    end
    
  end
end
