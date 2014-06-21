module Socializer
  class ActivityObject < ActiveRecord::Base
    attr_accessor :privacy, :object_ids
    attr_accessible :privacy, :object_ids, :activitable_id, :activitable_type, :like_count, :unread_notifications_count

    belongs_to :activitable, polymorphic: true

    has_many :notifications
    has_many :audiences # , dependent: :destroy
    has_many :activities, through: :audiences

    has_many :actor_activities,  class_name: 'Activity', foreign_key: 'actor_id',  dependent: :destroy
    has_many :object_activities, class_name: 'Activity', foreign_key: 'activity_object_id', dependent: :destroy
    has_many :target_activities, class_name: 'Activity', foreign_key: 'target_id', dependent: :destroy

    # when the embedded object is an actor (person/group)
    # it can be the owner of certain objects.
    has_many :notes,      foreign_key: 'author_id'
    has_many :comments,   foreign_key: 'author_id'
    has_many :groups,     foreign_key: 'author_id'
    has_many :circles,    foreign_key: 'author_id'

    has_many :ties,        foreign_key: 'contact_id'
    has_many :memberships, -> { where active: true }, foreign_key: 'member_id'

    # Create predicate methods for comparing the activitable_type
    #
    # @param  *args [Array] The activitable_type(s)
    #
    # @return [Object] The predicate method
    def self.attribute_type_of(*args)
      args.each do |type|
        define_method("#{type}?") { activitable_type == "Socializer::#{type.capitalize}" }
      end
    end

    attribute_type_of :note, :activity, :comment, :person, :group, :circle

    # REFACTOR: DRY this up. Reduce database calls
    # TODO: Rename this method to liked_by
    def likes
      people = []
      query  = Activity.joins(:verb).where(activity_object_id: id)

      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # activities_likes = query.where(verb: { name: 'like' })
      activities_likes = query.where(socializer_verbs: { name: 'like' })
      # Alternate syntax:
      # activities_likes = query.where(verb: Verb.where(name: 'like'))
      activities_likes.each do |activity|
        people << activity.actor
      end

      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # activities_unlikes = query.where(verb: { name: 'unlike' })
      activities_unlikes = query.where(socializer_verbs: { name: 'unlike' })
      # Alternate syntax:
      # activities_unlikes = query.where(verb: Verb.where(name: 'unlike'))
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
      # REFACTOR : check for validation?
      ActivityCreator.create!(actor_id: actor_id,
                              activity_object_id: id,
                              verb: 'share',
                              object_ids: object_ids,
                              content: content)
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
      public = Audience.privacy.find_value(:public).value.split(',')

      ActivityCreator.create!(actor_id: actor.activity_object.id,
                              activity_object_id: id,
                              verb: verb,
                              object_ids: public)
    end

    def increment_like_count
      increment!(:like_count)
    end

    def decrement_like_count
      decrement!(:like_count)
    end
  end
end
