module Socializer
  class Activity < ActiveRecord::Base
    include Socializer::Object

    has_and_belongs_to_many :embedded_objects, class_name: 'EmbeddedObject', join_table: 'socializer_audiences', foreign_key: "activity_id", association_foreign_key: "object_id"

    has_many   :audiences,           class_name: 'Audience',       foreign_key: 'activity_id'#, dependent: :destroy
    has_many   :children,            class_name: 'Activity',       foreign_key: 'parent_id',   dependent: :destroy

    belongs_to :parent,              class_name: 'Activity',       foreign_key: 'parent_id'
    belongs_to :embeddable_actor,    class_name: 'EmbeddedObject', foreign_key: 'actor_id'
    belongs_to :embeddable_object,   class_name: 'EmbeddedObject', foreign_key: 'object_id'
    belongs_to :embeddable_target,   class_name: 'EmbeddedObject', foreign_key: 'target_id'

    attr_accessible :parent_id, :verb, :circles, :actor_id, :object_id, :target_id, :content

    default_scope { order('created_at DESC') }

    def comments
      @comments ||= children
    end

    def actor
      @actor ||= embeddable_actor.embeddable
    end

    def object
      @object ||= embeddable_object.embeddable
    end

    def target
      @target ||= embeddable_target.embeddable
    end

    # retrieve all the activites that either the person made, that is public from a person in
    # one of his circle or that is shared to one of the circle he is part of
    # possible arguments :
    #   args[:provider]  => nil, activities, people, circles, groups
    #   args[:actor_id]  => unique identifier of the previously typed provider
    #   args[:viewer_id] => who wants to see the activity stream
    scope :stream, lambda { |args|

      viewer_id = Person.find(args[:viewer_id]).guid

      # for an activity to be interesting, it must correspond to one of these verbs
      verbs_of_interest = ["post", "share"]

      # To be allowed to see an activity, one of the following must be true
      # 1) You are the author
      # 2) Someone in your circles is the author and one of the following is true :
      #    a) It's audience is PUBLIC
      #    b) It's audience is CIRCLES and you are part of the author's circles
      #    c) It's audience is LIMITED and you are either :
      #       i)  A contact in one of the audience listed circles
      #       ii) Directly tagged as an allowed audience

      # Audience : PUBLIC
      public_sql   = "socializer_audiences.scope = 'PUBLIC'"

      # Audience : CIRCLES
      # Retrieve the author's unique identifier
      actor_id_sql = "SELECT socializer_embedded_objects.id " +
                     "FROM socializer_embedded_objects " +
                     "INNER JOIN socializer_people " +
                     "ON socializer_embedded_objects.embeddable_id = socializer_people.id " +
                     "WHERE socializer_people.id = socializer_activities.actor_id"

      # Retrieve the author's circles
      actor_circles_sql = "SELECT socializer_circles.id " +
                          "FROM socializer_circles  " +
                          "WHERE socializer_circles.author_id IN ( #{actor_id_sql} ) "

      # Ensure the audience is CIRCLES and then make sure that the viewer is in those circles
      circles_sql  = "socializer_audiences.scope = 'CIRCLES' " +
                     "AND #{viewer_id} IN ( #{actor_circles_sql} )"

      # Audience : LIMITED
      # Retrieve the circle's unique identifier related to the audience (when the audience
      # is not a circle, this query will simply return nothing)
      limited_circle_id_sql = "SELECT socializer_circles.id " +
                              "FROM socializer_circles " +
                              "INNER JOIN socializer_embedded_objects " +
                              "ON socializer_circles.id = socializer_embedded_objects.embeddable_id " +
                                  "AND socializer_embedded_objects.embeddable_type = 'Socializer::Circle' " +
                              "WHERE socializer_embedded_objects.id = socializer_audiences.object_id "

      # Retrieve all the contacts (people) that are part of those circles
      limited_followed_sql = "SELECT socializer_ties.contact_id " +
                             "FROM socializer_ties " +
                             "WHERE socializer_ties.circle_id IN ( #{limited_circle_id_sql} )"

      # Retrieve all the groups that the viewer is member of.
      limited_groups_sql = "SELECT socializer_embedded_objects.id " +
                           "FROM socializer_memberships " +
                           "INNER JOIN socializer_embedded_objects " +
                           "ON socializer_embedded_objects.embeddable_id = socializer_memberships.group_id " +
                               "AND socializer_embedded_objects.embeddable_type = 'Socializer::Group' " +
                           "WHERE socializer_memberships.member_id = #{viewer_id}"

      # Ensure that the audience is LIMITED and then make sure that the viewer is either
      # part of a circle that is the target audience, or that the viewer is part of
      # a group that is the target audience, or that the viewer is the target audience.
      limited_sql  = "socializer_audiences.scope = 'LIMITED' " +
                     "AND ( #{viewer_id} IN ( #{limited_followed_sql} ) " +
                        "OR socializer_audiences.object_id IN ( #{limited_groups_sql} ) " +
                        "OR socializer_audiences.object_id = #{viewer_id} ) "

      # Build full audience sql string
      security_sql = "( ( #{public_sql} ) OR ( #{circles_sql} ) OR ( #{limited_sql} ) OR actor_id = #{viewer_id} )"

      if args[:provider].nil?

        # this is your dashboard. display everything about people in circles and yourself.
        joins(:audiences).where(verb: verbs_of_interest).where(parent_id: nil).where(security_sql).uniq

      else

        if args[:provider] == 'activities'

          # we only want to display a single activity. make sure the viwer is allowed to do so.
          activity_id = args[:actor_id]
          joins(:audiences).where(verb: verbs_of_interest).where("id = #{activity_id}").where(parent_id: nil).where(security_sql).uniq

        elsif args[:provider] == 'people'

          # this is a user profile. display everything about him that you are allowed to see
          person_id = Person.find(args[:actor_id]).guid
          joins(:audiences).where(verb: verbs_of_interest).where("actor_id = #{person_id}").where(parent_id: nil).where(security_sql).uniq

        elsif args[:provider] == 'circles'

          # this is a circle. display everything that was posted by contacts in that circle.
          viewer_id = Person.find(args[:viewer_id]).guid
          circle_id = Circle.find(args[:actor_id]).id
          circles_sql  = "SELECT socializer_circles.id FROM socializer_circles WHERE author_id = #{viewer_id} AND id = #{circle_id}"
          followed_sql = "SELECT socializer_ties.contact_id FROM socializer_ties WHERE socializer_ties.circle_id IN ( #{circles_sql} )"
          joins(:audiences).where(verb: verbs_of_interest).where("actor_id IN ( #{followed_sql} )").where(parent_id: nil).where(security_sql).uniq

        elsif args[:provider] == 'groups'

          # this is a group. display everything that was posted to this group as audience
          group_id = Group.find(args[:actor_id]).guid
          joins(:audiences).where(verb: verbs_of_interest).where("socializer_audiences.object_id = #{group_id}").where(parent_id: nil).where(security_sql).uniq

        else

          raise "Unknown stream provider."

        end

      end
    }

  end
end
