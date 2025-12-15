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

    # Orders the activities by their creation time in descending order.
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    #   a relation of activities ordered by `created_at` in descending order.
    #
    # @example
    #   Socializer::Activity.newest_first
    #   # => Returns the activities ordered from newest to oldest based on
    #   # => their creation time.
    def self.newest_first
      order(created_at: :desc)
    end

    # Find activities where the id is equal to the given id
    #
    # @param id [Integer] the ID of the record to find
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    #   the records matching the given ID
    #
    # @example Find record with specific ID
    #   Socializer::Activity.with_id(id: 1)
    #   # => Returns the activity with ID 1
    def self.with_id(id:)
      where(id:)
    end

    # Find activities where the activity\_object\_id is equal to the given id
    #
    # @param id [Integer] the ID of the activity object
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    #   the records matching the given activity\_object\_id
    #
    # @example Find activities with a specific activity_object_id
    #   Socializer::Activity.with_activity_object_id(id: 1)
    #   # => Returns the activities with activity_object_id 1
    def self.with_activity_object_id(id:)
      where(activity_object_id: id)
    end

    # Find activities where the actor_id is equal to the given id
    #
    # @param id [Integer] the ID of the actor
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    #   the records matching the given actor ID
    #
    # @example Find activities with a specific actor ID
    #   Socializer::Activity.with_actor_id(id: 1)
    #   # => Returns the activities with actor ID 1
    def self.with_actor_id(id:)
      where(actor_id: id)
    end

    # Find activities where the target_id is equal to the given id
    #
    # @param id [Integer] the ID of the target
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>]
    #   the records matching the given target ID
    #
    # @example Find activities with a specific target ID
    #   Socializer::Activity.with_target_id(id: 1)
    #   # => Returns the activities with target ID 1
    def self.with_target_id(id:)
      where(target_id: id)
    end

    # Returns a filtered, newest-first stream of activities for the specified viewer.
    #
    # @param viewer_id [Integer] the ID of the viewer requesting the stream
    #
    # @return [ActiveRecord::Relation<Socializer::Activity>] the filtered activity stream
    #
    # @example
    #   Socializer::Activity.stream(viewer_id: 1)
    #   # => Returns the activity stream for the viewer with ID 1
    def self.stream(viewer_id:)
      person_id = Person.find_by(id: viewer_id).guid
      stream_query(viewer_id: person_id).newest_first.distinct
    end

    # Retrieves a distinct activity stream for a specific actor and viewer.
    #
    # @param actor_uid [Integer] The unique identifier of the actor.
    # @param viewer_id [Integer] The unique identifier of the viewer.
    #
    # @return [Socializer::Activity] The filtered activity stream scoped by `viewer_id` and associated with
    #   the `actor_uid`.
    def self.activity_stream(actor_uid:, viewer_id:)
      stream_query(viewer_id:).with_id(id: actor_uid).distinct
    end

    # Display all activities for a given circle
    #
    # @param actor_uid [Integer] The unique identifier of the actor (circle).
    # @param viewer_id [Integer] The unique identifier of the viewer.
    #
    # @return [Socializer::Activity] The filtered activity stream scoped by
    #   `viewer_id` and associated with the `actor_uid`.
    #
    # @example
    #   Socializer::Activity.circle_stream(actor_uid: 1, viewer_id: 2)
    #   # => Returns the activity stream for the circle with actor_uid 1 and viewer_id 2
    #
    # FIXME: Should display notes even if circle has no members and the owner
    #   is viewing it.
    #   Notes still don't show after adding people to the circles.
    def self.circle_stream(actor_uid:, viewer_id:)
      circles = Circle.with_id(id: actor_uid)
                      .with_author_id(id: viewer_id).ids

      followed = Tie.with_circle_id(circle_id: circles).pluck(:contact_id)

      stream_query(viewer_id:).with_actor_id(id: followed).distinct
    end

    # Retrieves a distinct activity stream for a specific group and viewer.
    #
    # @param actor_uid [Integer] The unique identifier of the group.
    # @param viewer_id [Integer] The unique identifier of the viewer.
    #
    # @return [Socializer::Activity] The filtered activity stream scoped by `viewer_id` and associated with
    #   the `actor_uid`.
    #
    # @example
    #   Socializer::Activity.group_stream(actor_uid: 1, viewer_id: 2)
    #   # => Returns the activity stream for the group with ID 1 and viewer with ID 2
    def self.group_stream(actor_uid:, viewer_id:)
      group_id = Group.find_by(id: actor_uid).guid

      stream_query(viewer_id:)
        .merge(Audience.with_activity_object_id(id: group_id)).distinct
    end

    # Class Method: person_query
    #
    # Retrieves a distinct stream of activities for a specified person.
    #
    # This method finds the `Person` record associated with the given
    # `actor_uid`, retrieves their globally unique `guid`, and then queries
    # the activity stream for activities related to that `Person`, scoped to
    # the given `viewer_id`. The results are returned in a distinct manner to
    # avoid duplicate entries.
    #
    # @param actor_uid [Integer] The ID of the actor (Person) whose stream is
    #   to be fetched.
    #
    # @param viewer_id [Integer] The ID of the viewer requesting the stream.
    #
    # @return [Socializer::Activity, nil]
    #   The filtered activity stream scoped by `viewer_id`
    #   and associated with the `actor_uid`. Returns `nil` if the `Person`
    #   record is not found.
    #
    # @example Fetching the activity stream for a person
    #   # Assuming we have a person with actor_uid = 1 and viewer_id = 2
    #   stream = Socializer::Activity.person_stream(actor_uid: 1, viewer_id: 2)
    #   stream.each do |activity|
    #     puts activity.content
    #   end
    def self.person_stream(actor_uid:, viewer_id:)
      person = Person.find_by(id: actor_uid)
      return unless person # Handle case where person is nil

      stream_query(viewer_id:).with_actor_id(id: person.guid).distinct
    end

    # Class Methods - Private

    # Class Method: stream_query
    #
    # This method constructs a query to fetch activities that are of interest
    # to a viewer.
    #
    # @param viewer_id [Integer] The ID of the viewer for whom the activities
    #   are being queried.
    #
    # @return [Socializer::Activity]
    #   A query object that can be used to fetch activities.
    #
    # The method filters activities based on the following criteria:
    # - The activity must correspond to one of the verbs of interest, which
    #   are 'post' and 'share'.
    # - The activity must be associated with a public or limited privacy
    #   grouping that includes the viewer, or the viewer must be the actor
    #   of the activity.
    #
    # @example
    #   Activity.stream_query(viewer_id: 1)
    def self.stream_query(viewer_id:)
      # for an activity to be interesting, it must correspond to one of these
      # verbs
      verbs_of_interest = %w[post share]
      query = joins(:audiences, :verb)
              .merge(Verb.with_display_name(name: verbs_of_interest))
              .with_target_id(id: nil)

      query.where(Audience.public_privacy_grouping(viewer_id:)
           .or(Audience.limited_privacy_grouping(viewer_id:))
           .or(Audience.where(actor_id: viewer_id)))
    end
    private_class_method :stream_query

    # Instance Methods

    # Returns true if activity has comments
    #
    # @return [TrueClass, FalseClass]
    #
    # @example
    #   activity.comments?
    def comments?
      comments.exists?
    end

    # Retrieves the comments for an activity
    #
    # @return [Socializer::Activity] a collection of
    # {Socializer::Activity} objects
    def comments
      return @comments if defined?(@comments)

      activitable_type =
        ActivityObject.with_activitable_type(type: Comment.name)

      @comments = children.joins(:activitable_object).merge(activitable_type)
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
