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
    has_many :audiences, inverse_of: :activity # , dependent: :destroy
    has_many :activity_objects, through: :audiences
    has_many :children, class_name: 'Activity', foreign_key: 'target_id', dependent: :destroy
    has_many :notifications, inverse_of: :activity

    # Validations
    validates :activitable_actor, presence: true
    validates :activitable_object, presence: true
    validates :verb, presence: true

    # Named Scopes
    scope :newest_first, -> { order(created_at: :desc) }
    scope :by_activity_object_id, -> id { where(activity_object_id: id) }
    scope :by_actor_id, -> id { where(actor_id: id) }
    scope :by_target_id, -> id { where(target_id: id) }

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
      @comments ||= children.joins(:activitable_object)
                            .merge(ActivityObject.by_activitable_type(Comment.name))
    end

    # The {Socializer::Person} that performed the activity.
    #
    # @return [Socializer::Person]
    def actor
      activitable_actor.activitable
    end

    # The primary object of the activity.
    #
    # @return the activitable object
    def object
      activitable_object.activitable
    end

    # The target of the activity. The precise meaning of the activity target is dependent on the activities verb,
    # but will often be the object the English preposition "to".
    #
    # @return the activitable target
    def target
      activitable_target.activitable
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
    def self.stream(viewer_id:)
      person_id = Person.find_by(id: viewer_id).guid
      stream_query(viewer_id: person_id).newest_first.distinct
    end

    # We only want to display a single activity. Make sure the viewer is allowed to do so.
    #
    # @param  actor_uid: [FixNum] unique identifier of the previously typed provider
    # @param  viewer_id: [FixNum] who wants to see the activity stream
    #
    # @return [ActiveRecord::Relation]
    def self.activity_stream(actor_uid:, viewer_id:)
      stream_query(viewer_id: viewer_id).where(socializer_activities: { id: actor_uid }).distinct
    end

    # TODO: [self description]
    #
    # @param  actor_uid: [FixNum] unique identifier of the previously typed provider
    # @param  viewer_id: [FixNum] who wants to see the activity stream
    #
    # @return [ActiveRecord::Relation]
    #
    # FIXME: Should display notes even if circle has no members and the owner is viewing it.
    #        Notes still don't show after adding people to the circles.
    #
    def self.circle_stream(actor_uid:, viewer_id:)
      circles  = Circle.by_id(actor_uid).by_author_id(viewer_id).pluck(:id)
      followed = Tie.by_circle_id(circles).pluck(:contact_id)

      stream_query(viewer_id: viewer_id).where(socializer_activities: { actor_id: followed }).distinct
    end

    # This is a group. display everything that was posted to this group as audience
    #
    # @param  actor_uid: [FixNum] unique identifier of the previously typed provider
    # @param  viewer_id: [FixNum] who wants to see the activity stream
    #
    # @return [ActiveRecord::Relation]
    def self.group_stream(actor_uid:, viewer_id:)
      group_id = Group.find_by(id: actor_uid).guid
      stream_query(viewer_id: viewer_id).merge(Audience.by_activity_object_id(group_id)).distinct
    end

    # This is a user profile. display everything about them that you are allowed to see
    #
    # @param  actor_uid: [FixNum] unique identifier of the previously typed provider
    # @param  viewer_id: [FixNum] who wants to see the activity stream
    #
    # @return [ActiveRecord::Relation]
    def self.person_stream(actor_uid:, viewer_id:)
      person_id = Person.find_by(id: actor_uid).guid
      stream_query(viewer_id: viewer_id).where(socializer_activities: { actor_id: person_id }).distinct
    end

    # Class Methods - Private

    # TODO: [self description]
    #
    # @param  viewer_id: [FixNum] who wants to see the activity stream
    #
    # @return [ActiveRecord::Relation]
    def self.stream_query(viewer_id:)
      # FIXME: Notes shared with Circles don't show in the stream
      #         The note doesn't display in the owners stream or in a circle members stream

      # for an activity to be interesting, it must correspond to one of these verbs
      verbs_of_interest = %w(post share)

      query = joins(:audiences, :verb).merge(Verb.by_display_name(verbs_of_interest)).by_target_id(nil)

      # privacy levels
      privacy_public  = Audience.privacy.public.value
      privacy_circles = Audience.privacy.circles.value
      privacy_limited = Audience.privacy.limited.value

      # The arel_table method is technically private since it is marked :nodoc
      audience       ||= Audience.arel_table
      privacy_field  ||= audience[:privacy]
      viewer_literal ||= Arel::Nodes::SqlLiteral.new("#{viewer_id}")

      circles_grouping = audience.grouping(privacy_field.eq(privacy_circles).and(viewer_literal.in(circles_subquery)))
      public_grouping  = audience.grouping(privacy_field.eq(privacy_public).or(circles_grouping))
      limited_grouping = audience.grouping(privacy_field.eq(privacy_limited)
                                  .and(viewer_literal.in(limited_circle_subquery)
                                    .or(audience[:activity_object_id].in(limited_group_subquery(viewer_id)))
                                  .or(audience[:activity_object_id].in(viewer_id))))

      query.where(public_grouping.or(limited_grouping).or(arel_table[:actor_id].eq(viewer_id)))
    end
    private_class_method :stream_query

    # Audience : CIRCLES
    # Ensure the audience is CIRCLES and then make sure that the viewer is in those circles
    #
    # @return [ActiveRecord::Relation]
    def self.circles_subquery
      # Retrieve the author's unique identifier
      subquery = ActivityObject.joins(:person).pluck(:id)
      Circle.by_author_id(subquery).pluck(:id)
    end
    private_class_method :circles_subquery

    # Audience : LIMITED
    # Ensure that the audience is LIMITED and then make sure that the viewer is either
    # part of a circle that is the target audience, or that the viewer is part of
    # a group that is the target audience, or that the viewer is the target audience.
    #
    # @return [ActiveRecord::Relation]
    def self.limited_circle_subquery
      # Retrieve the circle's unique identifier related to the audience (when the audience
      # is not a circle, this query will simply return nothing)
      subquery = Circle.joins(activity_object: :audiences).pluck(:id)
      Tie.by_circle_id(subquery).pluck(:contact_id)
    end
    private_class_method :limited_circle_subquery

    # TODO: [self description]
    #
    # @param  viewer_id: [FixNum] who wants to see the activity stream
    #
    # @return [ActiveRecord::Relation]
    def self.limited_group_subquery(viewer_id)
      ActivityObject.joins(group: :memberships)
                    .merge(Membership.by_member_id(viewer_id))
                    .pluck(:id)
    end
    private_class_method :limited_group_subquery
  end
end
