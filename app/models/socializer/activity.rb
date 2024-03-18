# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Activity model
  #
  # {Socializer::Activity} objects are specializations of the base
  # {Socializer::ObjectTypeBase Object}
  # type that provide information about pending, ongoing or completed actions.
  #
  # Activities follow the {https://activitystrea.ms/ Activity Streams} standard.
  #
  class Activity < ApplicationRecord
    include ObjectTypeBase

    # Relationships
    belongs_to :parent, class_name: "Socializer::Activity",
                        foreign_key: "target_id",
                        optional: true,
                        inverse_of: :children

    belongs_to :activitable_actor,  class_name: "Socializer::ActivityObject",
                                    foreign_key: "actor_id",
                                    inverse_of: :actor_activities

    belongs_to :activitable_object, class_name: "Socializer::ActivityObject",
                                    foreign_key: "activity_object_id",
                                    inverse_of: :object_activities

    belongs_to :activitable_target, class_name: "Socializer::ActivityObject",
                                    foreign_key: "target_id",
                                    inverse_of: :target_activities,
                                    optional: true

    belongs_to :verb, inverse_of: :activities

    has_one :activity_field,
            inverse_of: :activity,
            dependent: :delete

    has_one :actor, through: :activitable_actor,
                    source: :activitable,
                    source_type: "Socializer::Person",
                    dependent: :destroy

    has_many :audiences, inverse_of: :activity, dependent: :destroy
    has_many :activity_objects, through: :audiences, dependent: :destroy

    has_many :children, class_name: "Socializer::Activity",
                        foreign_key: "target_id",
                        dependent: :destroy,
                        inverse_of: :parent

    has_many :notifications,
             inverse_of: :activity,
             dependent: :delete_all

    # Validations

    # Named Scopes

    delegate :content, to: :activity_field, prefix: true, allow_nil: true
    delegate :display_name, to: :verb, prefix: true

    # Class Methods

    # Order records by created_at in descending order
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    def self.newest_first
      order(created_at: :desc)
    end

    # Find activities where the id is equal to the given id
    #
    # @param id: [Integer]
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    def self.with_id(id:)
      where(id:)
    end

    # Find activities where the activity_object_id is equal to the given id
    #
    # @param id: [Integer]
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    def self.with_activity_object_id(id:)
      where(activity_object_id: id)
    end

    # Find activities where the actor_id is equal to the given id
    #
    # @param id: [Integer]
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    def self.with_actor_id(id:)
      where(actor_id: id)
    end

    # Find activities where the target_id is equal to the given id
    #
    # @param id: [Integer]
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    def self.with_target_id(id:)
      where(target_id: id)
    end

    # Selects the activities that either the person owns, that are public from
    # a person in
    # one of their circles, or that are shared to one of the circles they are
    # part of.
    #
    # @example
    #   Activity.stream(provider: nil,
    #                   actor_id: current_user.id,
    #                   viewer_id: current_user.id)
    #
    # @param  provider: nil [String] <tt>nil</tt>,
    #                                <tt>activities</tt>,
    #                                <tt>people</tt>,
    #                                <tt>circles</tt>,
    #                                <tt>groups</tt>
    #
    # @param  actor_uid: [Integer] unique identifier of the previously typed
    # provider
    # @param  viewer_id: [Integer] who wants to see the activity stream
    #
    # @return [Socializer::Activity]
    def self.stream(viewer_id:)
      person_id = Person.find_by(id: viewer_id).guid
      stream_query(viewer_id: person_id).newest_first.distinct
    end

    # We only want to display a single activity. Make sure the viewer is
    # allowed to do so.
    #
    # @param  actor_uid: [Integer] unique identifier of the previously typed
    # provider
    # @param  viewer_id: [Integer] who wants to see the activity stream
    #
    # @return [Socializer::Activity]
    def self.activity_stream(actor_uid:, viewer_id:)
      stream_query(viewer_id:).with_id(id: actor_uid).distinct
    end

    # Display all activities for a given circle
    #
    # @param  actor_uid: [Integer] unique identifier of the previously typed
    # provider
    # @param  viewer_id: [Integer] who wants to see the activity stream
    #
    # @return [Socializer::Activity]
    #
    # FIXME: Should display notes even if circle has no members and the owner
    #        is viewing it.
    #        Notes still don't show after adding people to the circles.
    #
    def self.circle_stream(actor_uid:, viewer_id:)
      circles = Circle.with_id(id: actor_uid)
                      .with_author_id(id: viewer_id).ids

      followed = Tie.with_circle_id(circle_id: circles).pluck(:contact_id)

      stream_query(viewer_id:).with_actor_id(id: followed).distinct
    end

    # This is a group. display everything that was posted to this group as
    # audience
    #
    # @param  actor_uid: [Integer] unique identifier of the previously typed
    # provider
    # @param  viewer_id: [Integer] who wants to see the activity stream
    #
    # @return [Socializer::Activity]
    def self.group_stream(actor_uid:, viewer_id:)
      group_id = Group.find_by(id: actor_uid).guid

      stream_query(viewer_id:)
        .merge(Audience.with_activity_object_id(id: group_id)).distinct
    end

    # This is a user profile. display everything about them that you are
    # allowed to see
    #
    # @param  actor_uid: [Integer] unique identifier of the previously typed
    # provider
    # @param  viewer_id: [Integer] who wants to see the activity stream
    #
    # @return [Socializer::Activity]
    def self.person_stream(actor_uid:, viewer_id:)
      person_id = Person.find_by(id: actor_uid).guid
      stream_query(viewer_id:).with_actor_id(id: person_id).distinct
    end

    # Class Methods - Private

    # Build the stream query
    #
    # @param  viewer_id: [Integer] who wants to see the activity stream
    #
    # @return [Socializer::Activity]
    def self.stream_query(viewer_id:)
      # for an activity to be interesting, it must correspond to one of these
      # verbs
      verbs_of_interest = %w[post share]
      query = joins(:audiences, :verb)
              .merge(Verb.with_display_name(name: verbs_of_interest))
              .with_target_id(id: nil)

      query.where(Audience.public_privacy_grouping(viewer_id:)
           .or(Audience.limited_privacy_grouping(viewer_id:))
           .or(where(actor_id: viewer_id)))
    end
    private_class_method :stream_query

    # Instance Methods

    # Returns true if activity has comments
    #
    # @example
    #   activity.comments?
    #
    # @return [TrueClass, FalseClass]
    def comments?
      comments.exists?
    end

    # Retrieves the comments for an activity
    #
    # @return [Socializer::Activity] a collection of
    # {Socializer::Activity} objects
    def comments
      activitable_type =
        ActivityObject.with_activitable_type(type: Comment.name)

      @comments ||= children.joins(:activitable_object)
                            .merge(activitable_type)
    end

    # The primary object of the activity.
    #
    # @return the activitable object
    def object
      activitable_object.activitable
    end

    # The target of the activity. The precise meaning of the activity target is
    # dependent on the activities verb,
    # but will often be the object the English preposition "to".
    #
    # @return the activitable target
    def target
      activitable_target.activitable
    end
  end
end
