# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Activity Object model
  #
  class ActivityObject < ApplicationRecord
    attr_accessor :scope, :object_ids

    # Relationships
    belongs_to :activitable, polymorphic: true

    # Polymorphic
    # These relationships simplify the Activity.circles_subquery and
    # Activity.limited_group_subquery queries. By using these relationships we
    # no longer need to use Arel in those methods.
    has_one :self_reference,
            class_name: "ActivityObject",
            foreign_key: :id,
            dependent: nil

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

    has_many :notifications, inverse_of: :activity_object, dependent: :destroy
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
                    dependent: :destroy

    has_many :memberships,
             -> { Membership.active },
             foreign_key: "member_id",
             inverse_of: :activity_member,
             dependent: :destroy

    # Validations
    validates :activitable_type, presence: true

    # Named Scopes

    # Class Methods

    # Find activity objects where the id is equal to the given id
    #
    # @param id: [Integer]
    #
    # @return [Socializer::ActivityObject]
    def self.with_id(id:)
      where(id:)
    end

    # Find activity objects where the activitable_type is equal to the given
    # type
    #
    # @param type: [String]
    #
    # @return [Socializer::ActivityObject]
    def self.with_activitable_type(type:)
      where(activitable_type: type)
    end

    # Create predicate methods for comparing the activitable_type
    #
    # @param  *args [Array] The activitable_type(s)
    #
    # @return [Object] The predicate method
    def self.attribute_type_of(*args)
      args.each do |type|
        klass = "Socializer::#{type.to_s.classify}"
        define_method(:"#{type}?") { activitable_type == klass }
      end
    end

    attribute_type_of :note, :activity, :comment, :person, :group, :circle

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

      query    = Activity.joins(:verb).with_activity_object_id(id:)
      likers   = query.merge(Verb.with_display_name(name: "like"))
      unlikers = query.merge(Verb.with_display_name(name: "unlike"))
      people   = likers.map(&:actor)

      people.excluding(unlikers.map(&:actor))
    end

    # Reset unread_notifications_count to 0
    def reset_unread_notifications
      return if unread_notifications_count.zero?

      update!(unread_notifications_count: 0)
    end
  end
end
