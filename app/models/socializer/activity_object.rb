module Socializer
  class ActivityObject < ActiveRecord::Base
    attr_accessor :scope, :object_ids
    attr_accessible :scope, :object_ids, :activitable_id, :activitable_type, :like_count, :unread_notifications_count

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

    # define a class macro for setting comparaison with activitable_type
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
      query  =  Activity.joins { verb }.where { activity_object_id.eq(my { id }) }

      activities_likes = query.where { verb.name.eq('like') }
      activities_likes.each do |activity|
        people.push activity.actor
      end

      activities_unlikes = query.where { verb.name.eq('unlike') }
      activities_unlikes.each do |activity|
        people.delete_at people.index(activity.actor)
      end

      people
    end

    def like!(person)
      activity = Activity.create! do |a|
        a.actor_id = person.activity_object.id
        a.activity_object_id = id
        a.verb = Verb.find_or_create_by(name: 'like')
      end

      Audience.create!(privacy_level: :public, activity_id: activity.id)

      increment_like_count
    end

    def unlike!(person)
      activity = Activity.create! do |a|
        a.actor_id = person.activity_object.id
        a.activity_object_id = id
        a.verb = Verb.find_or_create_by(name: 'unlike')
      end

      Audience.create!(privacy_level: :public, activity_id: activity.id)

      decrement_like_count
    end

    # Share the activity with an audience
    # @param actor_id [Integer] User who share the activity (current_user)
    # @param object_ids [Array<Integer>] List of audiences to target
    # @param content [String] Text with the share
    def share!(actor_id, object_ids, content)
      # REFACTOR : check for validation?
      return unless object_ids.present? && actor_id.present?

      public  = Audience.privacy_level.find_value(:public).value.to_s
      circles = Audience.privacy_level.find_value(:circles).value.to_s

      activity = Activity.new do |a|
        a.actor_id = actor_id
        a.activity_object_id = id
        a.verb = Verb.find_or_create_by(name: 'share')
      end

      activity.build_activity_field(content: content) if content

      object_ids.split(',').each do |object_id|
        # REFACTOR: remove duplication
        if object_id == public || object_id == circles
          activity.audiences.build(privacy_level: object_id)
        else
          activity.audiences.build do |a|
            a.privacy_level = :limited
            a.activity_object_id = object_id
          end
        end
      end

      activity.save!
    end

    def increment_unread_notifications_count
      increment!(:unread_notifications_count)
    end

    private

    def increment_like_count
      increment!(:like_count)
    end

    def decrement_like_count
      decrement!(:like_count)
    end
  end
end
