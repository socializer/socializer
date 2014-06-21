module Socializer
  class Activity < ActiveRecord::Base
    include ObjectTypeBase

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
    delegate :name, to: :verb, prefix: true

    # Returns true if activity has comments
    #
    # @example
    #   activity.comments?
    #
    # @return [TrueClass, FalseClass]
    def comments?
      comments.present?
    end

    def comments
      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # @comments ||= children.joins(:activitable_object).where(activity_objects: { activitable_type: 'Socializer::Comment' })
      @comments ||= children.joins(:activitable_object).where(socializer_activity_objects: { activitable_type: 'Socializer::Comment' })
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
      object_ids = object_ids.split(',') if %w(Fixnum String).include?(object_ids.class.name)
      limited    = Audience.privacy_level.find_value(:limited).value.to_s

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
        query.distinct
      when 'activities'
        # we only want to display a single activity. make sure the viewer is allowed to do so.
        query.where(id: actor_uid).distinct
      when 'people'
        # this is a user profile. display everything about him that you are allowed to see
        person_id = Person.find_by(id: actor_uid).guid
        query.where(actor_id: person_id).distinct
      when 'circles'
        # FIXME: Should display notes even if circle has no members and the owner is viewing it.
        #        Notes still don't show after adding people to the circles.

        circles  = Circle.select(:id).where(id: actor_uid, author_id: viewer_id)
        followed = Tie.select(:contact_id).where(circle_id: circles)

        query.where(actor_id: followed).distinct
      when 'groups'
        # this is a group. display everything that was posted to this group as audience
        group_id = Group.find_by(id: actor_uid).guid
        # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
        # query.where(audiences: { activity_object_id: group_id }).distinct
        query.where(socializer_audiences: { activity_object_id: group_id }).distinct
      else
        fail 'Unknown stream provider.'
      end
    end

    # Class Methods - Private
    # CLEANUP: Remove old/unused code
    def self.build_query(viewer_id:)
      # for an activity to be interesting, it must correspond to one of these verbs
      verbs_of_interest = %w(post share)

      # privacy levels
      privacy         = Audience.privacy
      privacy_public  = privacy.find_value(:public).value
      privacy_circles = privacy.find_value(:circles).value
      privacy_limited = privacy.find_value(:limited).value

      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # query = joins(:audiences, :verb).where(verb: { name: verbs_of_interest }, target_id: nil)
      query = joins(:audiences, :verb).where(socializer_verbs: { name: verbs_of_interest }, target_id: nil)
      # Alternate syntax:
      # query = joins(:audiences, :verb).where(verb: Verb.where(name: verbs_of_interest), target_id: nil)

      # The arel_table method is technically private since it is marked :nodoc
      audience       ||= Audience.arel_table
      viewer_literal ||= Arel::SqlLiteral.new("#{viewer_id}")

      # TODO: Test: Generate the same SQL as below
      query.where(audience[:privacy].eq(privacy_public)
           .or(audience[:privacy].eq(privacy_circles)
             .and(viewer_literal.in(build_circles_subquery)))
           .or(audience[:privacy].eq(privacy_limited)
             .and(viewer_literal.in(build_limited_circle_subquery))
             .or(audience[:activity_object_id].in(build_limited_group_subquery(viewer_id)))
             .or(audience[:activity_object_id].in(viewer_id)))
           .or(arel_table[:actor_id].eq(viewer_id)))

      # query.where { (audiences.privacy.eq(privacy_public)) |
      #   ((audiences.privacy.eq(privacy_circles)) & `#{viewer_id}`.in(my { build_circles_subquery })) |
      #   ((audiences.privacy.eq(privacy_limited)) & (
      #     # `#{viewer_id}`.in(my { build_limited_circle_subquery(viewer_id) }) |
      #     `#{viewer_id}`.in(my { build_limited_circle_subquery }) |
      #     audiences.activity_object_id.in(my { build_limited_group_subquery(viewer_id) }) |
      #     # audiences.activity_object_id.in(my { build_limited_viewer_subquery(viewer_id) })
      #     audiences.activity_object_id.in(viewer_id)
      #   )) |
      #   (actor_id.eq(viewer_id)) }
    end
    private_class_method :build_query

    # Audience : CIRCLES
    # Ensure the audience is CIRCLES and then make sure that the viewer is in those circles
    def self.build_circles_subquery
      # TODO: Verify this works correcly
      # CLEANUP: Remove old code

      # Retrieve the author's unique identifier
      # The arel_table method is technically private since it is marked :nodoc
      person   ||= Person.arel_table
      ao       ||= ActivityObject.arel_table
      subquery = ao.project(ao[:id]).join(person).on(person[:id].eq(ao[:activitable_id]).and(ao[:activitable_type].eq(Person.name)))
      # subquery = ActivityObject.select { id }.joins { activitable(Person) }
      Circle.select(:id).where(author_id: subquery).arel

      # subquery = 'SELECT socializer_activity_objects.id ' \
      #            'FROM socializer_activity_objects ' \
      #            'INNER JOIN socializer_people ' \
      #            'ON socializer_activity_objects.activitable_id = socializer_people.id ' \
      #            'WHERE socializer_people.id = socializer_activities.actor_id'
      #
      # Circle.select { id }.where { author_id.in(`#{subquery}`) }
    end
    private_class_method :build_circles_subquery

    # Audience : LIMITED
    # Ensure that the audience is LIMITED and then make sure that the viewer is either
    # part of a circle that is the target audience, or that the viewer is part of
    # a group that is the target audience, or that the viewer is the target audience.
    # CLEANUP: Remove old code
    # TODO: Verify this works correcly
    # def self.build_limited_circle_subquery(viewer_id)
    def self.build_limited_circle_subquery
      # Retrieve the circle's unique identifier related to the audience (when the audience
      # is not a circle, this query will simply return nothing)
      subquery = Circle.select(:id).joins(activity_object: :audiences)
      Tie.select(:contact_id).where(circle_id: subquery).arel

      # limited_circle_id_sql = 'SELECT socializer_circles.id ' \
      #                         'FROM socializer_circles ' \
      #                         'INNER JOIN socializer_activity_objects ' \
      #                         'ON socializer_circles.id = socializer_activity_objects.activitable_id ' \
      #                             "AND socializer_activity_objects.activitable_type = 'Socializer::Circle' " \
      #                         'WHERE socializer_activity_objects.id = socializer_audiences.activity_object_id '
      #
      # # Retrieve all the contacts (people) that are part of those circles
      # Tie.select { contact_id }.where { circle_id.in(`#{limited_circle_id_sql}`) }
      #
      # # Ensure that the audience is LIMITED and then make sure that the viewer is either
      # # part of a circle that is the target audience, or that the viewer is part of
      # # a group that is the target audience, or that the viewer is the target audience.
      # # limited_sql = Audience.with_privacy(:limited).where{(`"#{viewer_id}"`.in(actor_circles_sql)) | (activity_object_id.in(limited_groups_sql)) | (activity_object_id.eq(viewer_id))}
    end
    private_class_method :build_limited_circle_subquery

    def self.build_limited_group_subquery(viewer_id)
      # The arel_table method is technically private since it is marked :nodoc
      ao         ||= ActivityObject.arel_table
      membership ||= Membership.arel_table
      group      ||= Group.arel_table

      ao.project(ao[:id]).join(group).on(group[:id].eq(ao[:activitable_id]).and(ao[:activitable_type].eq(Group.name)))
                         .join(membership).on(membership[:group_id].eq(group[:id]))
                         .where(membership[:member_id].eq(viewer_id))

      # CLEANUP: Remove old code
      # join       = ao.join(group).on(group[:id].eq(ao[:activitable_id]).and(ao[:activitable_type].eq(Group.name)))
      #                .join(membership).on(membership[:group_id].eq(group[:id])).join_sql

      # ActivityObject.select(:id).joins(join).where(membership[:member_id].eq(viewer_id)).arel
      # ActivityObject.select { id }.joins { activitable(Group).memberships }.where { socializer_memberships.member_id.eq(viewer_id) }
    end
    private_class_method :build_limited_group_subquery

    # CLEANUP: Remove old/unused code
    # def self.build_limited_viewer_subquery(viewer_id)
    #   "( #{viewer_id} )"
    # end
    # private_class_method :build_limited_viewer_subquery
  end
end
