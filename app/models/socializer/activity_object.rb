module Socializer
  class ActivityObject < ActiveRecord::Base

    attr_accessor :scope, :object_ids
    attr_accessible :scope, :object_ids, :activitable_id, :activitable_type, :like_count

    belongs_to :activitable, polymorphic: true

    has_many :audiences #, dependent: :destroy
    has_many :activities, through: :audiences, source: :activity

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

    def likes
      people = []
      query  =  Activity.joins{verb}.where{activity_object_id.eq(self.id)}

      activities_likes = query.where{verb.name.eq('like')}
      activities_likes.each do |activity|
        people.push activity.actor
      end

      activities_unlikes = query.where{verb.name.eq('unlike')}
      activities_unlikes.each do |activity|
        people.delete_at people.index(activity.actor)
      end

      return people
    end

    def like!(person)
      activity = Activity.create! do |a|
        a.actor_id = person.activity_object.id
        a.activity_object_id = self.id
        a.verb = Verb.find_or_create_by(name: 'like')
      end

      Audience.create!(privacy_level: :public, activity_id: activity.id)

      increment_like_count
    end

    def unlike!(person)
      activity = Activity.create! do |a|
        a.actor_id = person.activity_object.id
        a.activity_object_id = self.id
        a.verb = Verb.find_or_create_by(name: 'unlike')
      end

      Audience.create!(privacy_level: :public, activity_id: activity.id)

      decrement_like_count
    end

    def share!
      public = Socializer::Audience.privacy_level.find_value(:public).value.to_s
      circles = Socializer::Audience.privacy_level.find_value(:circles).value.to_s

      activity = Activity.create! do |a|
        a.actor_id = self.actor_id
        a.activity_object_id = self.id
        a.verb = Verb.find_or_create_by(name: 'share')
      end

      if scope == public || scope == circles
        Audience.create!(privacy_level: scope, activity_id: activity.id)
      else
        object_ids.each do |object_id|
          Audience.create! do |a|
            a.activity_id = activity.id
            a.privacy_level = :limited
            a.activity_object_id = object_id
          end
        end
      end
    end

    def increment_like_count
      self.increment!(:like_count)
    end

    def decrement_like_count
      self.decrement!(:like_count)
    end

  end
end
