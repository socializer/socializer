#
# Namespace for the Socializer engine
#
module Socializer
  class ActivityObject < ActiveRecord::Base
    attr_accessor :scope, :object_ids
    attr_accessible :scope, :object_ids, :activitable_id, :activitable_type, :like_count, :unread_notifications_count

    # Relationships
    belongs_to :activitable, polymorphic: true

    # Polymorphic
    # These relationships simplify the Activity.circles_subquery and Activity.limited_group_subquery
    # queries. By using these relationships we no longer need to use Arel in those methods.
    # NOTE: These relationships will no longer be needed if rails provides a nice way to joins to a polymorphic
    #       relationship
    belongs_to :group,  -> { where(socializer_activity_objects: { activitable_type: Group.name }) }, foreign_key: 'activitable_id'
    belongs_to :person, -> { where(socializer_activity_objects: { activitable_type: Person.name }) }, foreign_key: 'activitable_id'

    has_many :notifications
    has_many :audiences # , dependent: :destroy
    has_many :activities, through: :audiences

    has_many :actor_activities,  class_name: 'Activity', foreign_key: 'actor_id',  dependent: :destroy
    has_many :object_activities, class_name: 'Activity', foreign_key: 'activity_object_id', dependent: :destroy
    has_many :target_activities, class_name: 'Activity', foreign_key: 'target_id', dependent: :destroy

    has_many :notes,      foreign_key: 'author_id'
    has_many :comments,   foreign_key: 'author_id'
    has_many :groups,     foreign_key: 'author_id'
    has_many :circles,    foreign_key: 'author_id'

    has_many :ties,        foreign_key: 'contact_id'
    has_many :memberships, -> { where active: true }, foreign_key: 'member_id'

    # Validations
    validates :activitable, presence: true

    # Create predicate methods for comparing the activitable_type
    #
    # @param  *args [Array] The activitable_type(s)
    #
    # @return [Object] The predicate method
    def self.attribute_type_of(*args)
      args.each do |type|
        define_method("#{type}?") { activitable_type == "Socializer::#{type.to_s.classify}" }
      end
    end

    attribute_type_of :note, :activity, :comment, :person, :group, :circle

    # A list of people that like this activity object
    #
    # @return [Array]
    # REFACTOR: DRY this up. Reduce database calls
    def liked_by
      # subquery = Activity.where(activity_object_id: id)
      # people   = Person.joins(activity_object: { actor_activities: :verb }).merge(subquery)
      # likers   = people.merge(Verb.by_display_name('like'))
      # unlikers = people.merge(Verb.by_display_name('unlike')).pluck(:id)

      # likers.where.not(id: unlikers)
      people = []
      query  = Activity.joins(:verb).where(activity_object_id: id)

      activities_likes   = query.merge(Verb.by_display_name('like'))
      activities_unlikes = query.merge(Verb.by_display_name('unlike'))

      activities_likes.each do |activity|
        people << activity.actor
      end

      activities_unlikes.each do |activity|
        people.delete_at people.index(activity.actor)
      end

      people
    end

    # Like the ActivityObject
    #
    # @example
    #   @likable.like!(current_user) unless current_user.likes?(@likable)
    #
    # @param person [Socializer::Person] The person who is liking the activity (current_user)
    #
    # @return [OpenStruct]
    def like!(person)
      results  = create_like_unlike_activity(actor: person, verb: 'like')

      increment_like_count if results.success?
      results
    end

    # Unlike the ActivityObject
    #
    # @example
    #   @likable.unlike!(current_user) if current_user.likes?(@likable)
    #
    # @param person [Socializer::Person] The person who is unliking the activity (current_user)
    #
    # @return [OpenStruct]
    def unlike!(person)
      results  = create_like_unlike_activity(actor: person, verb: 'unlike')

      decrement_like_count if results.success?
      results
    end

    # Share the activity with an audience
    #
    # @param actor_id [Integer] User who is sharing the activity (current_user)
    # @param object_ids [Array<Integer>] List of audiences to target
    # @param content [String] Text with the share
    #
    # @return [OpenStruct]
    def share!(actor_id:, object_ids:, content: nil)
      ActivityCreator.new(actor_id: actor_id,
                          activity_object_id: id,
                          verb: 'share',
                          object_ids: object_ids,
                          content: content).perform
    end

    def increment_unread_notifications_count
      increment!(:unread_notifications_count)
    end

    private

    # Create the activity for like and unlike.
    #
    # @param actor [Person] User who is liking/unliking the activity (current_user)
    # @param verb [String] Verb for the activity
    #
    # @return [OpenStruct]
    def create_like_unlike_activity(actor:, verb:)
      public = Audience.privacy_value(privacy: :public).split(',')

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
