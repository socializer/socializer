#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Activity Object model
  #
  class ActivityObject < ActiveRecord::Base
    attr_accessor :scope, :object_ids
    attr_accessible :scope, :object_ids, :activitable_id, :activitable_type,
                    :like_count, :unread_notifications_count

    # Relationships
    belongs_to :activitable, polymorphic: true

    # Polymorphic
    # These relationships simplify the Activity.circles_subquery and
    # Activity.limited_group_subquery queries. By using these relationships we
    # no longer need to use Arel in those methods.
    # NOTE: These relationships will no longer be needed if rails provides a
    #       nice way to joins to a polymorphic relationship
    belongs_to :group,  -> { where(socializer_activity_objects: { activitable_type: Group.name }) }, foreign_key: "activitable_id"
    belongs_to :person, -> { where(socializer_activity_objects: { activitable_type: Person.name }) }, foreign_key: "activitable_id"

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
    scope :by_id, -> id { where(id: id) }
    scope :by_activitable_type, -> type { where(activitable_type: type) }

    # Class Methods

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
      # people   = Person.joins(activity_object: { actor_activities: :verb }).merge(subquery)
      # likers   = people.merge(Verb.by_display_name("like"))
      # unlikers = people.merge(Verb.by_display_name("unlike")).pluck(:id)

      # likers.where.not(id: unlikers)
      query    = Activity.joins(:verb).by_activity_object_id(id)
      likers   = query.merge(Verb.by_display_name("like"))
      unlikers = query.merge(Verb.by_display_name("unlike"))
      people   = likers.map(&:actor)

      unlikers.each do |activity|
        people.delete_at people.index(activity.actor)
      end

      people
    end

    # Like the ActivityObject
    #
    # @example
    #   @likable.like(current_user) unless current_user.likes?(@likable)
    #
    # @param person [Socializer::Person] The person who is liking the activity
    # (current_user)
    #
    # @return [Socializer::Activity]
    def like(person)
      results  = create_like_unlike_activity(actor: person, verb: "like")

      increment_like_count if results.persisted?
      results
    end

    # Unlike the ActivityObject
    #
    # @example
    #   @likable.unlike(current_user) if current_user.likes?(@likable)
    #
    # @param person [Socializer::Person] The person who is unliking the
    # activity (current_user)
    #
    # @return [Socializer::Activity]
    def unlike(person)
      results  = create_like_unlike_activity(actor: person, verb: "unlike")

      decrement_like_count if results.persisted?
      results
    end

    # Share the activity with an audience
    #
    # @example
    #   @shareable.share(actor_id: actor.guid,
    #                    object_ids: object_ids,
    #                    content: "This is the content")
    #
    # @param actor_id [Integer] User who is sharing the activity (current_user)
    # @param object_ids [Array<Integer>] List of audiences to target
    # @param content [String] Text with the share
    #
    # @return [Socializer::Activity]
    def share(actor_id:, object_ids:, content: nil)
      ActivityCreator.new(actor_id: actor_id,
                          activity_object_id: id,
                          verb: "share",
                          object_ids: object_ids,
                          content: content).perform
    end

    # Increments the unread_notifications_count by 1 and saves the record
    def increment_unread_notifications_count
      increment!(:unread_notifications_count)
    end

    # Reset unread_notifications_count to 0
    def reset_unread_notifications
      update!(unread_notifications_count: 0) if unread_notifications_count > 0
    end

    private

    # Create the activity for like and unlike.
    #
    # @param actor [Person] User who is liking/unliking the activity
    # (current_user)
    # @param verb [String] Verb for the activity
    #
    # @return [Socializer::Activity]
    def create_like_unlike_activity(actor:, verb:)
      public = Audience.privacy.public.value.split(",")

      ActivityCreator.new(actor_id: actor.guid,
                          activity_object_id: id,
                          verb: verb,
                          object_ids: public).perform
    end

    def increment_like_count
      increment!(:like_count)
    end

    def decrement_like_count
      decrement!(:like_count)
    end
  end
end
