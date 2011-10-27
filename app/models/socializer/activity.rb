module Socializer
  class Activity < ActiveRecord::Base
    include Socializer::EmbeddedObjectBase
    
    has_and_belongs_to_many :embedded_objects, :class_name => 'EmbeddedObject', :join_table => 'socializer_audiences', :foreign_key => "activity_id", :association_foreign_key => "object_id"
    
    has_many   :audiences,           :class_name => 'Audience',       :foreign_key => 'activity_id'#, :dependent => :destroy
    has_many   :children,            :class_name => 'Activity',       :foreign_key => 'parent_id',   :dependent => :destroy
    
    belongs_to :parent,              :class_name => 'Activity',       :foreign_key => 'parent_id'
    belongs_to :embeddable_actor,    :class_name => 'EmbeddedObject', :foreign_key => 'actor_id'
    belongs_to :embeddable_object,   :class_name => 'EmbeddedObject', :foreign_key => 'object_id'
    belongs_to :embeddable_target,   :class_name => 'EmbeddedObject', :foreign_key => 'target_id'
    
    attr_accessible :parent_id, :verb, :circles, :actor_id, :object_id, :target_id, :content
    
    default_scope :order => 'created_at DESC'
    
    def actor
      embeddable_actor.embeddable
    end
    
    def object
      embeddable_object.embeddable
    end
    
    def target
      embeddable_target.embeddable
    end
    
    def comments
      children
    end
    
    # retrieve all the activites that either the person made, that is public from a person in
    # one of his circle or that is shared to one of the circle he is part of
    # possible arguments :
    #   args[:provider]  => nil, activities, people, circles, groups
    #   args[:actor_id]  => unique identifier of the previously typed provider
    #   args[:viewer_id] => who wants to see the activity stream
    scope :stream, lambda { |args| 
      
      # for an activity to be interesting, it must correspond to one of these verbs
      viewer_id = Person.find(args[:viewer_id]).guid
      actor_id_sql = "SELECT socializer_embedded_objects.id FROM socializer_embedded_objects INNER JOIN socializer_people ON socializer_embedded_objects.embeddable_id = socializer_people.id WHERE socializer_people.id = socializer_activities.actor_id"
      verbs_of_interest = ["post", "share"]
      
      # to be able to read the activity, it must meet one of the following conditions :
      # 1) Public
      # 2) Circles and you are part of one circle of the poster
      # 3) Limited and one of your circles is the audience, or you directly are.
      # 4) It's your post
      
      public_sql   = "socializer_audiences.scope = 'PUBLIC'"
      
      actor_circles_sql = "SELECT socializer_circles.id " +
                          "FROM socializer_circles  " +
                          "WHERE socializer_circles.author_id IN ( #{actor_id_sql} ) "
                          
      actor_followed_sql = "SELECT socializer_ties.contact_id " +
                           "FROM socializer_ties " +
                           "WHERE socializer_ties.circle_id IN ( #{actor_circles_sql} )"
      
      circles_sql  = "socializer_audiences.scope = 'CIRCLES' AND ( #{viewer_id} IN ( #{actor_circles_sql} OR socializer_audiences.object_id = #{viewer_id} ) ) "
      
      limited_circle_id_sql = "SELECT socializer_circles.id " +
                              "FROM socializer_circles " +
                              "INNER JOIN socializer_embedded_objects " +
                              "ON socializer_circles.id = socializer_embedded_objects.embeddable_id " +
                              "WHERE socializer_embedded_objects.id = socializer_audiences.object_id "
      
      limited_followed_sql = "SELECT socializer_ties.contact_id " +
                             "FROM socializer_ties " +
                             "WHERE socializer_ties.circle_id IN ( #{limited_circle_id_sql} )"
                            
      limited_groups_sql = "SELECT socializer_embedded_objects.id " +
                           "FROM socializer_memberships " +
                           "INNER JOIN socializer_embedded_objects ON socializer_embedded_objects.embeddable_id = socializer_memberships.group_id AND socializer_embedded_objects.embeddable_type = 'Socializer::Group' " +
                           "WHERE socializer_memberships.member_id = #{viewer_id}"
                            
      limited_sql  = "socializer_audiences.scope = 'LIMITED' AND ( #{viewer_id} IN ( #{limited_followed_sql} ) OR socializer_audiences.object_id = #{viewer_id} OR socializer_audiences.object_id IN ( #{limited_groups_sql} ) ) "
      
      security_sql = "( ( #{public_sql} ) OR ( #{circles_sql} ) OR ( #{limited_sql} ) OR actor_id = #{viewer_id} )"
      
      if args[:provider].nil?
        # this is your dashboard. display everything about people in circles and yourself.
        
        circles_sql  = "SELECT socializer_circles.id " +
                       "FROM socializer_circles  " +
                       "WHERE socializer_circles.author_id = ( #{viewer_id} ) "
                          
        followed_sql = "SELECT socializer_ties.contact_id " +
                       "FROM socializer_ties " +
                       "WHERE socializer_ties.circle_id IN ( #{circles_sql} )"
        
        clause = "actor_id IN ( #{followed_sql} ) OR actor_id = #{viewer_id}"
        
        joins(:audiences).where(:verb => verbs_of_interest).where(clause).where(:parent_id => nil).where(security_sql).uniq
        
      else
        
        if args[:provider] == 'activities'
          # we only want to display a single activity. make sure the viwer is allowed to do so.
          
          activity_id  = args[:actor_id]
          clause = "id = #{activity_id}"
          
          joins(:audiences).where(:verb => verbs_of_interest).where(clause).where(:parent_id => nil).where(security_sql).uniq
          
        elsif args[:provider] == 'people'
          # this is a user profile. display everything about him that you are allowed to see
          
          actor_id = Person.find(args[:actor_id]).guid
          clause = "actor_id = #{actor_id}"
          
          joins(:audiences).where(:verb => verbs_of_interest).where(clause).where(:parent_id => nil).where(security_sql).uniq
          
        elsif args[:provider] == 'circles'
          # this is a circle. display everything that was posted to this circle as audience
          # and everything public 
          
          viewer_id = Person.find(args[:viewer_id]).guid
          circle_id = Circle.find(args[:actor_id]).id
          circles_sql  = "SELECT socializer_circles.id FROM socializer_circles WHERE author_id = #{viewer_id} AND id = #{circle_id}"
          followed_sql = "SELECT socializer_ties.contact_id FROM socializer_ties WHERE socializer_ties.circle_id IN ( #{circles_sql} )"
          clause = "actor_id IN ( #{followed_sql} )"
        
          joins(:audiences).where(:verb => verbs_of_interest).where(clause).where(:parent_id => nil).where(security_sql).uniq
          
        elsif args[:provider] == 'groups'
          # this is the posts for a certain group. we should see all posts that has
          # this particular group as audience.
          
          group_id = Group.find(args[:actor_id]).guid
          clause = "socializer_audiences.object_id = #{group_id}"
          
          joins(:audiences).where(:verb => verbs_of_interest).where(clause).where(:parent_id => nil).where(security_sql).uniq
          
        else
          
          raise "Unknown stream provider."
          
        end
        
      end
    }
    
  end
end
