#
# Namespace for the Socializer engine
#
module Socializer
  class Activity < ActiveRecord::Base
    include ObjectTypeBase

    attr_accessible :verb, :circles, :actor_id, :activity_object_id, :target_id

    # Relationships
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

    # Validations
    validates :activitable_actor, presence: true
    validates :activitable_object, presence: true
    validates :verb, presence: true

    # Named Scopes
    scope :newest_first, -> { order(created_at: :desc) }

    delegate :content, to: :activity_field, prefix: true, allow_nil: true
    delegate :display_name, to: :verb, prefix: true

    # Returns true if activity has comments
    #
    # @example
    #   activity.comments?
    #
    # @return [TrueClass, FalseClass]
    def comments?
      comments.present?
    end

    # Retrieves the comments for an activity
    #
    # @return [ActiveRecord::AssociationRelation] a collection of {Socializer::Activity} objects
    def comments
      # FIXME: Rails 5.0 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying
      #        joins/includes
      # @comments ||= children.joins(:activitable_object)
      #                       .where(activity_objects: { activitable_type: 'Socializer::Comment' })
      @comments ||= children.joins(:activitable_object)
                            .where(socializer_activity_objects: { activitable_type: 'Socializer::Comment' })
    end

    # The {Socializer::Person} that performed the activity.
    #
    # @return [Socializer::Person]
    def actor
      @actor ||= activitable_actor.activitable
    end

    # The primary object of the activity.
    #
    # @return the activitable object
    def object
      @object ||= activitable_object.activitable
    end

    # The target of the activity. The precise meaning of the activity target is dependent on the activities verb,
    # but will often be the object the English preposition "to".
    #
    # @return the activitable target
    def target
      @target ||= activitable_target.activitable
    end

    # Selects the activities that either the person owns, that are public from a person in
    # one of their circles, or that are shared to one of the circles they are part of.
    #
    # @example
    #   Activity.stream(provider: nil, actor_id: current_user.id, viewer_id: current_user.id)
    #
    # @param  provider: nil [String] <tt>nil</tt>, <tt>activities</tt>, <tt>people</tt>, <tt>circles</tt>,
    #                                <tt>groups</tt>
    # @param  actor_uid: [FixNum] unique identifier of the previously typed provider
    # @param  viewer_id: [FixNum] who wants to see the activity stream
    #
    # @return [ActiveRecord::Relation]
    def self.stream(provider: nil, actor_uid:, viewer_id:)
      person_id = Person.find_by(id: viewer_id).guid
      return stream_query(viewer_id: person_id).newest_first.distinct if provider.blank?
      public_send("#{provider.singularize}_stream", actor_uid: actor_uid, viewer_id: person_id)
    end

    # we only want to display a single activity. make sure the viewer is allowed to do so.
    def self.activity_stream(actor_uid:, viewer_id:)
      stream_query(viewer_id: viewer_id).where(id: actor_uid).distinct
    end

    # FIXME: Should display notes even if circle has no members and the owner is viewing it.
    #        Notes still don't show after adding people to the circles.
    def self.circle_stream(actor_uid:, viewer_id:)
      circles  = Circle.select(:id).where(id: actor_uid, author_id: viewer_id)
      followed = Tie.select(:contact_id).where(circle_id: circles)

      stream_query(viewer_id: viewer_id).where(actor_id: followed).distinct
    end

    # this is a group. display everything that was posted to this group as audience
    def self.group_stream(actor_uid:, viewer_id:)
      group_id = Group.find_by(id: actor_uid).guid
      # FIXME: Rails 5.0 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying
      #        joins/includes
      # query.where(audiences: { activity_object_id: group_id }).distinct
      stream_query(viewer_id: viewer_id).where(socializer_audiences: { activity_object_id: group_id }).distinct
    end

    # this is a user profile. display everything about them that you are allowed to see
    def self.person_stream(actor_uid:, viewer_id:)
      person_id = Person.find_by(id: actor_uid).guid
      stream_query(viewer_id: viewer_id).where(actor_id: person_id).distinct
    end

    # Class Methods - Private
    def self.stream_query(viewer_id:)
      # CLEANUP: Remove old/unused code

      # for an activity to be interesting, it must correspond to one of these verbs
      verbs_of_interest = %w(post share)

      query = joins(:audiences, :verb).merge(Verb.by_display_name(verbs_of_interest)).where(target_id: nil)

      # privacy levels
      privacy_public  = Audience.privacy_value(privacy: :public)
      privacy_circles = Audience.privacy_value(privacy: :circles)
      privacy_limited = Audience.privacy_value(privacy: :limited)

      # The arel_table method is technically private since it is marked :nodoc
      audience       ||= Audience.arel_table
      privacy_field  ||= audience[:privacy]
      viewer_literal ||= Arel::Nodes::SqlLiteral.new("#{viewer_id}")

      # TODO: Test: Generate the same SQL as below
      query.where(privacy_field.eq(privacy_public)
           .or(privacy_field.eq(privacy_circles)
             .and(viewer_literal.in(circles_subquery)))
           .or(privacy_field.eq(privacy_limited)
             .and(viewer_literal.in(limited_circle_subquery))
             .or(audience[:activity_object_id].in(limited_group_subquery(viewer_id)))
             .or(audience[:activity_object_id].in(viewer_id)))
           .or(arel_table[:actor_id].eq(viewer_id)))

      # # rubocop:disable Lint/BlockAlignment, Style/Blocks
      # query.where { (audiences.privacy.eq(privacy_public)) |
      #   ((audiences.privacy.eq(privacy_circles)) & `#{viewer_id}`.in(my { circles_subquery })) |
      #   ((audiences.privacy.eq(privacy_limited)) & (
      #     `#{viewer_id}`.in(my { limited_circle_subquery }) |
      #     audiences.activity_object_id.in(my { limited_group_subquery(viewer_id) }) |
      #     audiences.activity_object_id.in(viewer_id)
      #   )) |
      #   (actor_id.eq(viewer_id)) }
      # # rubocop:enable Lint/BlockAlignment, Style/Blocks
    end
    private_class_method :stream_query

    # Audience : CIRCLES
    # Ensure the audience is CIRCLES and then make sure that the viewer is in those circles
    def self.circles_subquery
      # TODO: Verify this works correctly
      # CLEANUP: Remove old code

      # Retrieve the author's unique identifier
      # The arel_table method is technically private since it is marked :nodoc
      person   ||= Person.arel_table
      ao       ||= ActivityObject.arel_table
      subquery = ao.project(ao[:id]).join(person).on(person[:id].eq(ao[:activitable_id])
                     .and(ao[:activitable_type].eq(Person.name))).to_sql
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
    private_class_method :circles_subquery

    # Audience : LIMITED
    # Ensure that the audience is LIMITED and then make sure that the viewer is either
    # part of a circle that is the target audience, or that the viewer is part of
    # a group that is the target audience, or that the viewer is the target audience.
    def self.limited_circle_subquery
      # TODO: Verify this works correctly

      # Retrieve the circle's unique identifier related to the audience (when the audience
      # is not a circle, this query will simply return nothing)
      subquery = Circle.select(:id).joins(activity_object: :audiences)
      Tie.select(:contact_id).where(circle_id: subquery).arel
    end
    private_class_method :limited_circle_subquery

    def self.limited_group_subquery(viewer_id)
      # TODO: Verify this works correctly
      # CLEANUP: Remove old code

      # The arel_table method is technically private since it is marked :nodoc
      ao         ||= ActivityObject.arel_table
      membership ||= Membership.arel_table
      group      ||= Group.arel_table

      ao.project(ao[:id]).join(group).on(group[:id].eq(ao[:activitable_id]).and(ao[:activitable_type].eq(Group.name)))
                         .join(membership).on(membership[:group_id].eq(group[:id]))
                         .where(membership[:member_id].eq(viewer_id))

      # ActivityObject.select { id }.joins { activitable(Group).memberships }
      #               .where { socializer_memberships.member_id.eq(viewer_id) }
    end
    private_class_method :limited_group_subquery
  end
end
