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
    attr_accessible :scope, :object_ids, :activitable_id, :activitable_type,
                    :like_count, :unread_notifications_count

    # Relationships
    belongs_to :activitable, polymorphic: true

    # Polymorphic
    # These relationships simplify the Activity.circles_subquery and
    # Activity.limited_group_subquery queries. By using these relationships we
    # no longer need to use Arel in those methods.
    has_one :self_reference, class_name: self, foreign_key: :id

    has_one :group,
            through: :self_reference,
            source: :activitable,
            source_type: Group.name

    has_one :person,
            through: :self_reference,
            source: :activitable,
            source_type: Person.name

    has_many :notifications, inverse_of: :activity_object
    has_many :audiences, inverse_of: :activity_object # , dependent: :destroy
    has_many :activities, through: :audiences

    has_many :actor_activities, class_name: "Activity",
                                foreign_key: "actor_id",
                                dependent: :destroy

    has_many :object_activities, class_name: "Activity",
                                 foreign_key: "activity_object_id",
                                 dependent: :destroy

    has_many :target_activities, class_name: "Activity",
                                 foreign_key: "target_id",
                                 dependent: :destroy

    has_many :notes,    foreign_key: "author_id", inverse_of: :activity_author
    has_many :comments, foreign_key: "author_id", inverse_of: :activity_author
    has_many :groups,   foreign_key: "author_id", inverse_of: :activity_author
    has_many :circles,  foreign_key: "author_id", inverse_of: :activity_author
    has_many :contacts, through: :circles

    has_many :ties, foreign_key: "contact_id",
                    inverse_of: :activity_contact

    has_many :memberships,
             -> { Membership.active },
             foreign_key: "member_id",
             inverse_of: :activity_member

    # Validations
    validates :activitable, presence: true

    # Named Scopes

    # Class Methods

    # Find activitiy objects where the id is equal to the given id
    #
    # @param id: [Integer]
    #
    # @return [ActiveRecord::Relation]
    def self.with_id(id:)
      where(id: id)
    end

    # Find activitiy objects where the activitable_type is equal to the given
    # type
    #
    # @param type: [String]
    #
    # @return [ActiveRecord::Relation]
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
        define_method("#{type}?") { activitable_type == klass }
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

      query    = Activity.joins(:verb).with_activity_object_id(id: id)
      likers   = query.merge(Verb.with_display_name(name: "like"))
      unlikers = query.merge(Verb.with_display_name(name: "unlike"))
      people   = likers.map(&:actor)

      unlikers.each do |activity|
        people.delete_at people.index(activity.actor)
      end

      people
    end

    # Reset unread_notifications_count to 0
    def reset_unread_notifications
      update!(unread_notifications_count: 0) if unread_notifications_count > 0
    end
  end
end
