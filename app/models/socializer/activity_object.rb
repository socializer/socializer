# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Activity Object model
  class ActivityObject < ApplicationRecord
    # CLEANUP: Remove the attr_accessor and add the object_ids attribute
    # attr_accessor :scope, :object_ids
    # attribute :object_ids
    attribute :scope

    # Relationships
    belongs_to :activitable, polymorphic: true

    # Polymorphic
    # These relationships simplify the Audience.circles_subquery and
    # Audience.limited_group_subquery queries. By using these relationships we
    # no longer need to use Arel in those methods.
    has_one :self_reference,
            class_name: "Socializer::ActivityObject",
            foreign_key: :id,
            dependent: nil,
            inverse_of: :self_reference

    has_one :group,
            through: :self_reference,
            source: :activitable,
            source_type: Group.name,
            dependent: :destroy

    has_one :person,
            through: :self_reference,
            source: :activitable,
            source_type: Person.name,
            dependent: :destroy

    has_many :notifications,
             inverse_of: :activity_object,
             dependent: :delete_all

    has_many :audiences, inverse_of: :activity_object, dependent: :destroy
    has_many :activities, through: :audiences, dependent: :destroy

    has_many :actor_activities, class_name: "Socializer::Activity",
                                foreign_key: "actor_id",
                                dependent: :destroy,
                                inverse_of: :activitable_actor

    has_many :object_activities, class_name: "Socializer::Activity",
                                 dependent: :destroy,
                                 inverse_of: :activitable_object

    has_many :target_activities, class_name: "Socializer::Activity",
                                 foreign_key: "target_id",
                                 dependent: :destroy,
                                 inverse_of: :activitable_target

    has_many :notes,
             foreign_key: "author_id",
             inverse_of: :activity_author,
             dependent: :destroy

    has_many :comments,
             foreign_key: "author_id",
             inverse_of: :activity_author,
             dependent: :destroy

    has_many :groups,
             foreign_key: "author_id",
             inverse_of: :activity_author,
             dependent: :destroy

    has_many :circles,
             foreign_key: "author_id",
             inverse_of: :activity_author,
             dependent: :destroy

    has_many :contacts, through: :circles, dependent: :destroy

    has_many :ties, foreign_key: "contact_id",
                    inverse_of: :activity_contact,
                    dependent: :delete_all

    has_many :memberships,
             -> { Membership.active },
             foreign_key: "member_id",
             inverse_of: :activity_member,
             dependent: :delete_all

    # Validations
    validates :activitable_type, presence: true

    # Named Scopes

    # Class Methods

    # Find activity objects with the specified ID
    #
    # @param id [Integer] The ID to filter by
    #
    # @return [ActiveRecord::Relation<Socializer::ActivityObject>]
    #
    # @example
    #   Socializer::ActivityObject.with_id(id: 1)
    def self.with_id(id:)
      where(id:)
    end

    # Find activity objects with the specified activitable type
    #
    # @param type [String] The activitable type to filter by
    #
    # @return [ActiveRecord::Relation<Socializer::ActivityObject>]
    #
    # @example
    #   Socializer::ActivityObject.with_activitable_type(type: "Socializer::Note")
    def self.with_activitable_type(type:)
      where(activitable_type: type)
    end

    # Create predicate methods for comparing the activitable_type
    #
    # @param  types [Array] The activitable_type(s)
    #
    # @return [Object] The predicate method
    #
    # @example
    #   Socializer::ActivityObject.define_activitable_type_checkers(:note, :activity)
    def self.define_activitable_type_checkers(*types)
      types.each do |type|
        define_method(:"#{type}?") do
          activitable_type == "Socializer::#{type.to_s.classify}"
        end
      end
    end

    define_activitable_type_checkers :note, :activity, :comment,
                                     :person, :group, :circle

    # Instance Methods

    # A list of people that like this activity object
    #
    # @return [Array]
    # REFACTOR: DRY this up. Reduce database calls
    def liked_by
      # subquery = Activity.where(activity_object_id: id)
      # people   = Person.joins(activity_object: { actor_activities: :verb })
      #                  .merge(subquery)
      # likers   = people.merge(Verb.by_display_name("like"))
      # unlikers = people.merge(Verb.by_display_name("unlike")).pluck(:id)
      #
      # subquery = Activity.where(activity_object_id: id)
      # people = Person.joins(activity_object: { actor_activities: :verb })
      #                .where(actor_activities: { activity_id: subquery })
      #                .where(verbs: { display_name: "like" })
      #
      # unlikers = Person.joins(activity_object: { actor_activities: :verb })
      #                  .where(actor_activities: { activity_id: subquery })
      #                  .where(verbs: { display_name: "unlike" })

      # query = Activity.joins(:verb).with_activity_object_id(id:)
      # likers = query.merge(Verb.with_display_name(name: "like"))
      #               .pluck(:actor_id)
      # unlikers = query.merge(Verb.with_display_name(name: "unlike"))
      #                 .pluck(:actor_id)
      # return [] if likers.empty?
      # Person.where(id: likers - unlikers)

      query    = Activity.joins(:verb).with_activity_object_id(id:)
      likers   = query.merge(Verb.with_display_name(name: "like"))
      unlikers = query.merge(Verb.with_display_name(name: "unlike"))
      people   = likers.map(&:actor)

      people.excluding(unlikers.map(&:actor))

      # query = Activity.joins(:verb).with_activity_object_id(id:)
      # likers = query.merge(Verb.with_display_name(name: "like"))
      # unlikers = query.merge(Verb.with_display_name(name: "unlike"))
      #                 .select(:actor_id)
      # people = likers.joins(:actor)
      #                .where.not(actor_activities: { actor_id: unlikers })

      # people

      # Person.joins(activity_object: { actor_activities: :verb })
      #       .where(activity_object: { id: })
      #       .where(verbs: { display_name: "like" })
      #       .where.not(activity_object: { id: Activity.joins(:verb)
      #                      .with_activity_object_id(id:)
      #                      .merge(Verb.with_display_name(name: "unlike"))
      #                      .select(:id) })

      # people = Activity.joins(:verb)
      #                  .with_activity_object_id(id:)
      #                  .joins(:actor)
      #                  # .merge(Actor.with_display_name(name: "person"))
      #                  .where.not(verb: { display_name: "unlike" })
      #                  .where(verb: { display_name: "like" }).map(&:actor)
    end

    # Resets the unread notifications count to zero if it is not already zero.
    #
    # @example
    #   activity_object.reset_unread_notifications
    def reset_unread_notifications
      return if unread_notifications_count.zero?

      update!(unread_notifications_count: 0)
    end
  end
end
