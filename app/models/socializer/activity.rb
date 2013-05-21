module Socializer
  class Activity < ActiveRecord::Base
    include Socializer::ObjectTypeBase

    default_scope { order(created_at: :desc) }

    attr_accessible :verb, :circles, :actor_id, :object_id, :target_id, :content

    belongs_to :parent,              class_name: 'Activity',       foreign_key: 'target_id'
    belongs_to :activitable_actor,   class_name: 'ActivityObject', foreign_key: 'actor_id'
    belongs_to :activitable_object,  class_name: 'ActivityObject', foreign_key: 'object_id'
    belongs_to :activitable_target,  class_name: 'ActivityObject', foreign_key: 'target_id'

    has_many   :audiences,           class_name: 'Audience',       foreign_key: 'activity_id'#, dependent: :destroy
    has_many   :children,            class_name: 'Activity',       foreign_key: 'target_id',   dependent: :destroy

    has_and_belongs_to_many :activity_objects, class_name: 'ActivityObject', join_table: 'socializer_audiences', foreign_key: "activity_id", association_foreign_key: "object_id"

    def comments
      @comments ||= children
    end

    def actor
      @actor ||= activitable_actor.activitable
    end

    def object
      @object ||= activitable_object.activitable
    end

    def target
      @target ||= activitable_target.activitable
    end

    # sifter :verb_contains do |string|
    #   verb.eq(string)
    # end

    # scope :test, -> value { where{sift :verb_contains, value} if value.present? }
    # scope :test1, -> value { where(:audiences => {:privacy_level => value}) if value.present? }

    # retrieve all the activites that either the person made, that is public from a person in
    # one of his circle or that is shared to one of the circle he is part of
    # possible arguments :
    #   options[:provider]  => nil, activities, people, circles, groups
    #   options[:actor_id]  => unique identifier of the previously typed provider
    #   options[:viewer_id] => who wants to see the activity stream
    def self.stream(options = {})
      options.assert_valid_keys(:provider, :actor_id, :viewer_id)

      provider  = options.delete(:provider)
      actor_uid = options.delete(:actor_id)
      viewer_id = options.delete(:viewer_id)

      viewer_id = Person.find(viewer_id).guid

      query = build_query(viewer_id)

      case provider
      when nil
        # this is your dashboard. display everything about people in circles and yourself.
        query.uniq
      when 'activities'
        # we only want to display a single activity. make sure the viewer is allowed to do so.
        activity_id = actor_uid
        query.where{id.eq(activity_id)}.uniq
      when 'people'
        # this is a user profile. display everything about him that you are allowed to see
        person_id = Person.find(actor_uid).guid
        query.where{actor_id.eq(person_id)}.uniq
      when 'circles'
        # this is a circle. display everything that was posted by contacts in that circle.
        # viewer_id = Person.find(viewer_id).guid
        circle_uid   = Circle.find(actor_uid).id
        circles_sql  = Socializer::Circle.where{author_id.eq(viewer_id) & id.eq(circle_uid)}.select{id}
        followed_sql = Socializer::Tie.where{circle_id.in(circles_sql)}.select{contact_id}

        query.where{actor_id.in(followed_sql)}.uniq
      when 'groups'
        # this is a group. display everything that was posted to this group as audience
        group_id = Group.find(actor_uid).guid
        query.where(audiences: {object_id: group_id}).uniq
        # FIXME: the object_id reservered word appears to be interfering with using squeel here
        # query.where{audiences.object_id.eq(group_id)}.uniq
      else
        raise "Unknown stream provider."
      end
    end

    private

    def self.build_query(viewer_id)
      raise "viewer_id cannot be nil." if viewer_id.nil?

      # for an activity to be interesting, it must correspond to one of these verbs
      verbs_of_interest = ["post", "share"]

      # privacy_levels
      privacy_public  = Socializer::Audience.privacy_level.find_value(:public).value
      privacy_circles = Socializer::Audience.privacy_level.find_value(:circles).value
      privacy_limited = Socializer::Audience.privacy_level.find_value(:limited).value

      query = joins{audiences}.where{verb.in(verbs_of_interest)}.where{target_id.eq(nil)}
      query = query.where{(audiences.privacy_level == privacy_public) |
        ((audiences.privacy_level == privacy_circles) & `#{viewer_id}`.in(my{build_circles_subquery})) |
        ((audiences.privacy_level == privacy_limited) & `#{viewer_id}`.in(my{build_limited_subquery(viewer_id)})) |
        (actor_id == viewer_id)}
# debugger

#       # Build full audience sql string
#       security_sql = build_security_sql(viewer_id)

#       query = joins{audiences}.where{verb.in(verbs_of_interest)}.where{target_id.eq(nil)}.where{security_sql}
    end

    # Audience : CIRCLES
    # Ensure the audience is CIRCLES and then make sure that the viewer is in those circles
    def self.build_circles_subquery
      # Retrieve the author's unique identifier
      subquery = Socializer::ActivityObject.select{id}.joins{activitable(Socializer::Person)}.joins{activities}.where{activities.actor_id.eq(activitable(Socializer::Person).id)}
      Socializer::Circle.select{id}.where{author_id.in(subquery)}
    end

    # Audience : LIMITED
    # Ensure that the audience is LIMITED and then make sure that the viewer is either
    # part of a circle that is the target audience, or that the viewer is part of
    # a group that is the target audience, or that the viewer is the target audience.
    def self.build_limited_subquery(viewer_id)
      # limited_circle_query = Socializer::Circle.select{id}.joins{activity_object}
      # Socializer::Tie.select{contact_id}.where{circle_id.in(limited_circle_query)}

      privacy_limited = Socializer::Audience.privacy_level.find_value(:limited).value
      # Retrieve the circle's unique identifier related to the audience (when the audience
      # is not a circle, this query will simply return nothing)
      limited_circle_id_sql = "SELECT socializer_circles.id " +
                              "FROM socializer_circles " +
                              "INNER JOIN socializer_activity_objects " +
                              "ON socializer_circles.id = socializer_activity_objects.activitable_id " +
                                  "AND socializer_activity_objects.activitable_type = 'Socializer::Circle' " +
                              "WHERE socializer_activity_objects.id = socializer_audiences.object_id "

      # Retrieve all the contacts (people) that are part of those circles
      # limited_followed_sql = Socializer::Tie.select{contact_id}.where{circle_id.in(limited_circle_id_sql)}
      limited_followed_sql = "SELECT socializer_ties.contact_id " +
                             "FROM socializer_ties " +
                             "WHERE socializer_ties.circle_id IN ( #{limited_circle_id_sql} )"

      # Retrieve all the groups that the viewer is member of.
      limited_groups_sql = "SELECT socializer_activity_objects.id " +
                           "FROM socializer_memberships " +
                           "INNER JOIN socializer_activity_objects " +
                           "ON socializer_activity_objects.activitable_id = socializer_memberships.group_id " +
                               "AND socializer_activity_objects.activitable_type = 'Socializer::Group' " +
                           "WHERE socializer_memberships.member_id = #{viewer_id}"

      # FIXME: Use with_privacy_level(:limited)
      # Ensure that the audience is LIMITED and then make sure that the viewer is either
      # part of a circle that is the target audience, or that the viewer is part of
      # a group that is the target audience, or that the viewer is the target audience.
      # limited_sql = Socializer::Audience.with_privacy_level(:limited).where{(`"#{viewer_id}"`.in(actor_circles_sql)) | (object_id.in(limited_groups_sql)) | (object_id.eq(viewer_id))}
      limited_sql  = "socializer_audiences.privacy_level = #{privacy_limited} " +
                     "AND ( #{viewer_id} IN ( #{limited_followed_sql} ) " +
                        "OR socializer_audiences.object_id IN ( #{limited_groups_sql} ) " +
                        "OR socializer_audiences.object_id = #{viewer_id} ) "
    end

    # def self.build_security_sql(viewer_id)

    #   # privacy_levels
    #   privacy_public  = Socializer::Audience.privacy_level.find_value(:public).value
    #   privacy_circles = Socializer::Audience.privacy_level.find_value(:circles).value
    #   privacy_limited = Socializer::Audience.privacy_level.find_value(:limited).value

    #   # To be allowed to see an activity, one of the following must be true
    #   # 1) You are the author
    #   # 2) Someone in your circles is the author and one of the following is true :
    #   #    a) It's audience is PUBLIC
    #   #    b) It's audience is CIRCLES and you are part of the author's circles
    #   #    c) It's audience is LIMITED and you are either :
    #   #       i)  A contact in one of the audience listed circles
    #   #       ii) Directly tagged as an allowed audience

    #   # FIXME: Use with_privacy_level(:public)
    #   # Audience : PUBLIC
    #   # public_sql = Socializer::Audience.with_privacy_level(:public)
    #   # public_sql   = { audiences: { privacy_level: Socializer::Audience.privacy_level.find_value(:public).value } }
    #   public_sql   = "socializer_audiences.privacy_level = #{privacy_public}"

    #   # Audience : CIRCLES
    #   # Retrieve the author's unique identifier
    #   # FIXME: the activities.actor_id part isn't referencing the correct table. May need add .includes(:activities) or include a join to activities
    #   # actor_id_sql = Socializer::ActivityObject.select{id}.joins{activitable(Socializer::Person)}.joins{activities}.where{activities.actor_id.eq(activitable(Socializer::Person).id)}
    #   actor_id_sql = "SELECT socializer_activity_objects.id " +
    #                  "FROM socializer_activity_objects " +
    #                  "INNER JOIN socializer_people " +
    #                  "ON socializer_activity_objects.activitable_id = socializer_people.id " +
    #                  "WHERE socializer_people.id = socializer_activities.actor_id"

    #   # Retrieve the author's circles
    #   # actor_circles_sql = Socializer::Circle.select{id}.where{author_id.in(actor_id_sql)}
    #   actor_circles_sql = "SELECT socializer_circles.id " +
    #                       "FROM socializer_circles  " +
    #                       "WHERE socializer_circles.author_id IN ( #{actor_id_sql} ) "

    #   # FIXME: Use with_privacy_level(:circles)
    #   # Ensure the audience is CIRCLES and then make sure that the viewer is in those circles
    #   # circles_sql  = Socializer::Audience.with_privacy_level(:circles).where{`"#{viewer_id}"`.in(actor_circles_sql)}
    #   circles_sql  = "socializer_audiences.privacy_level = #{privacy_circles} " +
    #                  "AND #{viewer_id} IN ( #{actor_circles_sql} )"

    #   # Audience : LIMITED
    #   # Retrieve the circle's unique identifier related to the audience (when the audience
    #   # is not a circle, this query will simply return nothing)
    #   limited_circle_id_sql = "SELECT socializer_circles.id " +
    #                           "FROM socializer_circles " +
    #                           "INNER JOIN socializer_activity_objects " +
    #                           "ON socializer_circles.id = socializer_activity_objects.activitable_id " +
    #                               "AND socializer_activity_objects.activitable_type = 'Socializer::Circle' " +
    #                           "WHERE socializer_activity_objects.id = socializer_audiences.object_id "

    #   # Retrieve all the contacts (people) that are part of those circles
    #   # limited_followed_sql = Socializer::Tie.select{contact_id}.where{circle_id.in(limited_circle_id_sql)}
    #   limited_followed_sql = "SELECT socializer_ties.contact_id " +
    #                          "FROM socializer_ties " +
    #                          "WHERE socializer_ties.circle_id IN ( #{limited_circle_id_sql} )"

    #   # Retrieve all the groups that the viewer is member of.
    #   limited_groups_sql = "SELECT socializer_activity_objects.id " +
    #                        "FROM socializer_memberships " +
    #                        "INNER JOIN socializer_activity_objects " +
    #                        "ON socializer_activity_objects.activitable_id = socializer_memberships.group_id " +
    #                            "AND socializer_activity_objects.activitable_type = 'Socializer::Group' " +
    #                        "WHERE socializer_memberships.member_id = #{viewer_id}"

    #   # FIXME: Use with_privacy_level(:limited)
    #   # Ensure that the audience is LIMITED and then make sure that the viewer is either
    #   # part of a circle that is the target audience, or that the viewer is part of
    #   # a group that is the target audience, or that the viewer is the target audience.
    #   # limited_sql = Socializer::Audience.with_privacy_level(:limited).where{(`"#{viewer_id}"`.in(actor_circles_sql)) | (object_id.in(limited_groups_sql)) | (object_id.eq(viewer_id))}
    #   limited_sql  = "socializer_audiences.privacy_level = #{privacy_limited} " +
    #                  "AND ( #{viewer_id} IN ( #{limited_followed_sql} ) " +
    #                     "OR socializer_audiences.object_id IN ( #{limited_groups_sql} ) " +
    #                     "OR socializer_audiences.object_id = #{viewer_id} ) "

    #   # Build full audience sql string
    #   security_sql = "( ( #{public_sql} ) OR ( #{circles_sql} ) OR ( #{limited_sql} ) OR actor_id = #{viewer_id} )"
    # end
  end
end
