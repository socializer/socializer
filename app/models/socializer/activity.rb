module Socializer
  class Activity < ActiveRecord::Base
    include Socializer::ObjectTypeBase

    default_scope { order(created_at: :desc) }

    attr_accessible :verb, :circles, :actor_id, :activity_object_id, :target_id

    belongs_to :parent,             class_name: 'Activity',       foreign_key: 'target_id'
    belongs_to :activitable_actor,  class_name: 'ActivityObject', foreign_key: 'actor_id'
    belongs_to :activitable_object, class_name: 'ActivityObject', foreign_key: 'activity_object_id'
    belongs_to :activitable_target, class_name: 'ActivityObject', foreign_key: 'target_id'
    belongs_to :verb, inverse_of: :activities

    has_one  :activity_field, inverse_of: :activity
    has_many :audiences # , dependent: :destroy
    has_many :activity_objects, through: :audiences
    has_many :children, class_name: 'Activity', foreign_key: 'target_id', dependent: :destroy

    validates :verb, presence: true

    def comments
      @comments ||= children.joins(:activitable_object).where { activitable_object.activitable_type.eq('Socializer::Comment') }
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

    # Selects the activites that either the person made, that is public from a person in
    # one of his circle, or that is shared to one of the circles he is part of.
    #
    # * <tt>options[:provider]</tt>  - <tt>nil</tt>, <tt>activities</tt>, <tt>people</tt>, <tt>circles</tt>, <tt>groups</tt>
    # * <tt>options[:actor_id]</tt>  - unique identifier of the previously typed provider
    # * <tt>options[:viewer_id]</tt> - who wants to see the activity stream
    #
    #   Activity.stream(provider: nil, actor_id: current_user.id, viewer_id: current_user.id)
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
        query.where { id.eq(activity_id) }.uniq
      when 'people'
        # this is a user profile. display everything about him that you are allowed to see
        person_id = Person.find(actor_uid).guid
        query.where { actor_id.eq(person_id) }.uniq
      when 'circles'
        # FIXME: Should display notes even if circle has no members and the owner is viewing it.
        #        Notes still don't show after adding people to the circles.

        circles_sql  = Circle.select { id }.where { (id.eq actor_uid) & (author_id.eq viewer_id) }
        followed_sql = Tie.select { contact_id }.where { circle_id.in(circles_sql) }

        query.where { actor_id.in(followed_sql) }.uniq
      when 'groups'
        # this is a group. display everything that was posted to this group as audience
        group_id = Group.find(actor_uid).guid
        # query.where(audiences: {activity_object_id: group_id}).uniq
        query.where { audiences.activity_object_id.eq(group_id) }.uniq
      else
        fail 'Unknown stream provider.'
      end
    end

    private

    def self.build_query(viewer_id)
      fail 'viewer_id cannot be nil.' if viewer_id.nil?

      # for an activity to be interesting, it must correspond to one of these verbs
      verbs_of_interest = %w(post share)
      verbs_of_interest = Verb.where { name.in(verbs_of_interest) }

      # privacy_levels
      privacy_public  = Audience.privacy_level.find_value(:public).value
      privacy_circles = Audience.privacy_level.find_value(:circles).value
      privacy_limited = Audience.privacy_level.find_value(:limited).value

      query = joins { audiences }.where { verb_id.in(verbs_of_interest) }.where { target_id.eq(nil) }
      query = query.where { (audiences.privacy_level == privacy_public) |
        ((audiences.privacy_level == privacy_circles) & `#{viewer_id}`.in(my { build_circles_subquery })) |
        ((audiences.privacy_level == privacy_limited) & (
          `#{viewer_id}`.in(my { build_limited_subquery(viewer_id) }) |
          audiences.activity_object_id.in(my { build_limited_group_subquery(viewer_id) }) |
          audiences.activity_object_id.in(my { build_limited_viewer_subquery(viewer_id) })
        )) |
        (actor_id == viewer_id) }

      logger.debug ' =================================== '
      logger.debug query
      logger.debug ' =================================== '

      query
    end

    # Audience : CIRCLES
    # Ensure the audience is CIRCLES and then make sure that the viewer is in those circles
    def self.build_circles_subquery
      # TODO: Convert this to squeel

      # Retrieve the author's unique identifier
      subquery = 'SELECT socializer_activity_objects.id ' +
                 'FROM socializer_activity_objects ' +
                 'INNER JOIN socializer_people ' +
                 'ON socializer_activity_objects.activitable_id = socializer_people.id ' +
                 'WHERE socializer_people.id = socializer_activities.actor_id'

      Circle.select { id }.where { author_id.in(`#{subquery}`) }
    end

    # Audience : LIMITED
    # Ensure that the audience is LIMITED and then make sure that the viewer is either
    # part of a circle that is the target audience, or that the viewer is part of
    # a group that is the target audience, or that the viewer is the target audience.
    def self.build_limited_subquery(viewer_id)
      # TODO: Convert this to squeel

      # Retrieve the circle's unique identifier related to the audience (when the audience
      # is not a circle, this query will simply return nothing)
      limited_circle_id_sql = 'SELECT socializer_circles.id ' +
                              'FROM socializer_circles ' +
                              'INNER JOIN socializer_activity_objects ' +
                              'ON socializer_circles.id = socializer_activity_objects.activitable_id ' +
                                  "AND socializer_activity_objects.activitable_type = 'Socializer::Circle' " +
                              'WHERE socializer_activity_objects.id = socializer_audiences.activity_object_id '

      # Retrieve all the contacts (people) that are part of those circles
      Tie.select { contact_id }.where { circle_id.in(`#{limited_circle_id_sql}`) }

      # Ensure that the audience is LIMITED and then make sure that the viewer is either
      # part of a circle that is the target audience, or that the viewer is part of
      # a group that is the target audience, or that the viewer is the target audience.
      # limited_sql = Audience.with_privacy_level(:limited).where{(`"#{viewer_id}"`.in(actor_circles_sql)) | (activity_object_id.in(limited_groups_sql)) | (activity_object_id.eq(viewer_id))}
    end

    def self.build_limited_group_subquery(viewer_id)
      # Retrieve all the groups that the viewer is member of.
      # limited_groups_query = Membership.select{activity_member.id}.joins{activity_member}.joins{activity_member.activitable(Group)}.where{member_id == viewer_id}
      # limited_groups_sql = 'SELECT socializer_activity_objects.id ' +
      #                     'FROM socializer_memberships ' +
      #                     'INNER JOIN socializer_activity_objects ' +
      #                     'ON socializer_activity_objects.activitable_id = socializer_memberships.group_id ' +
      #                         "AND socializer_activity_objects.activitable_type = 'Socializer::Group' " +
      #                     "WHERE socializer_memberships.member_id = #{viewer_id}"

      ActivityObject.select { id }.joins { activitable(Membership).group }.where { activitable.member_id.eq(viewer_id) }
    end

    def self.build_limited_viewer_subquery(viewer_id)
      "( #{viewer_id} )"
    end

  end
end
