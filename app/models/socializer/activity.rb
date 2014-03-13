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
    has_many :notifications

    validates :verb, presence: true

    delegate :content, to: :activity_field, prefix: true, allow_nil: true

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

    # Add an audience to the activity
    #
    # @param object_ids [Array<Integer>] List of audiences to target
    def add_audience(object_ids)
      limited = Socializer::Audience.privacy_level.find_value(:limited).value.to_s

      object_ids = object_ids.split(',') if object_ids.class == Fixnum || object_ids.class == String

      object_ids.each do |object_id|
        audience = audiences.build(privacy_level: object_id)
        audience.activity_object_id = object_id if object_id == limited
      end
    end

    # Selects the activities that either the person made, that is public from a person in
    # one of his circle, or that is shared to one of the circles he is part of.
    #
    # @example
    #   Activity.stream(provider: nil, actor_id: current_user.id, viewer_id: current_user.id)
    #
    # @param  provider: nil [String] <tt>nil</tt>, <tt>activities</tt>, <tt>people</tt>, <tt>circles</tt>, <tt>groups</tt>
    # @param  actor_uid: [FixNum] unique identifier of the previously typed provider
    # @param  viewer_id: [FixNum] who wants to see the activity stream
    #
    # @return [ActiveRecord::Relation]
    def self.stream(provider: nil, actor_uid:, viewer_id:)
      viewer_id = Person.find_by(id: viewer_id).guid
      query     = build_query(viewer_id: viewer_id)

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
        person_id = Person.find_by(id: actor_uid).guid
        query.where { actor_id.eq(person_id) }.uniq
      when 'circles'
        # FIXME: Should display notes even if circle has no members and the owner is viewing it.
        #        Notes still don't show after adding people to the circles.

        circles_sql  = Circle.select { id }.where { (id.eq actor_uid) & (author_id.eq viewer_id) }
        followed_sql = Tie.select { contact_id }.where { circle_id.in(circles_sql) }

        query.where { actor_id.in(followed_sql) }.uniq
      when 'groups'
        # this is a group. display everything that was posted to this group as audience
        group_id = Group.find_by(id: actor_uid).guid
        # query.where(audiences: {activity_object_id: group_id}).uniq
        query.where { audiences.activity_object_id.eq(group_id) }.uniq
      else
        fail 'Unknown stream provider.'
      end
    end

    private

    def self.build_query(viewer_id:)
      # for an activity to be interesting, it must correspond to one of these verbs
      verbs_of_interest = %w(post share)
      verbs_of_interest = Verb.where { name.in(verbs_of_interest) }

      # privacy_levels
      privacy_level   = Socializer::Audience.privacy_level
      privacy_public  = privacy_level.find_value(:public).value
      privacy_circles = privacy_level.find_value(:circles).value
      privacy_limited = privacy_level.find_value(:limited).value

      query = joins { audiences }.where { verb_id.in(verbs_of_interest) }.where { target_id.eq(nil) }

      query.where { (audiences.privacy_level == privacy_public) |
        ((audiences.privacy_level == privacy_circles) & `#{viewer_id}`.in(my { build_circles_subquery })) |
        ((audiences.privacy_level == privacy_limited) & (
          `#{viewer_id}`.in(my { build_limited_circle_subquery(viewer_id) }) |
          audiences.activity_object_id.in(my { build_limited_group_subquery(viewer_id) }) |
          audiences.activity_object_id.in(my { build_limited_viewer_subquery(viewer_id) })
        )) |
        (actor_id == viewer_id) }
    end

    # Audience : CIRCLES
    # Ensure the audience is CIRCLES and then make sure that the viewer is in those circles
    def self.build_circles_subquery
      # TODO: Convert this to squeel

      # Retrieve the author's unique identifier
      # subquery = ActivityObject.select { id }.joins{ activitable(Person) }
      subquery = 'SELECT socializer_activity_objects.id ' \
                 'FROM socializer_activity_objects ' \
                 'INNER JOIN socializer_people ' \
                 'ON socializer_activity_objects.activitable_id = socializer_people.id ' \
                 'WHERE socializer_people.id = socializer_activities.actor_id'

      Circle.select { id }.where { author_id.in(`#{subquery}`) }
    end

    # Audience : LIMITED
    # Ensure that the audience is LIMITED and then make sure that the viewer is either
    # part of a circle that is the target audience, or that the viewer is part of
    # a group that is the target audience, or that the viewer is the target audience.
    def self.build_limited_circle_subquery(viewer_id)
      # TODO: Convert this to squeel

      # Retrieve the circle's unique identifier related to the audience (when the audience
      # is not a circle, this query will simply return nothing)
      # limited_circle_id_sql = Circle.select { id }.joins{ activity_object.audiences }
      limited_circle_id_sql = 'SELECT socializer_circles.id ' \
                              'FROM socializer_circles ' \
                              'INNER JOIN socializer_activity_objects ' \
                              'ON socializer_circles.id = socializer_activity_objects.activitable_id ' \
                                  "AND socializer_activity_objects.activitable_type = 'Socializer::Circle' " \
                              'WHERE socializer_activity_objects.id = socializer_audiences.activity_object_id '

      # Retrieve all the contacts (people) that are part of those circles
      Tie.select { contact_id }.where { circle_id.in(`#{limited_circle_id_sql}`) }

      # Ensure that the audience is LIMITED and then make sure that the viewer is either
      # part of a circle that is the target audience, or that the viewer is part of
      # a group that is the target audience, or that the viewer is the target audience.
      # limited_sql = Audience.with_privacy_level(:limited).where{(`"#{viewer_id}"`.in(actor_circles_sql)) | (activity_object_id.in(limited_groups_sql)) | (activity_object_id.eq(viewer_id))}
    end

    def self.build_limited_group_subquery(viewer_id)
      ActivityObject.select { id }.joins { activitable(Group).memberships }.where { socializer_memberships.member_id.eq(viewer_id) }
    end

    def self.build_limited_viewer_subquery(viewer_id)
      "( #{viewer_id} )"
    end
  end
end
