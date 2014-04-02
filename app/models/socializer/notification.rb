module Socializer
  class Notification < ActiveRecord::Base
    # Increment the number of unread notifications
    after_save { activity_object.increment_unread_notifications_count }

    default_scope { order(created_at: :desc) }

    attr_accessible :read

    # Relationships
    belongs_to :activity
    belongs_to :activity_object # Person, Group, ...

    # Validations
    validates :activity_id, presence: true
    validates :activity_object_id, presence: true

    # Class methods - Public
    def self.create_for_activity(activity)
      # Get all ties related to the audience of the activity
      potential_contact_id = get_potential_contact_id(activity.id)
      potential_contact_id.each do |t|
        # If the contact has the author of the activity in one of his circle.
        if person_in_circle?(t.contact_id, activity.activitable_actor.id)
          create_notification(activity, t.contact_id)
        end
      end
    end

    class << self
      # Class methods - Private

      private

      def create_notification(activity, contact_id)
        notification = Notification.new do |n|
          n.activity = activity
          n.activity_object = ActivityObject.find_by(id: contact_id)
        end

        notification.save!
      end

      def get_potential_contact_id(activity_id)
        # Activity -> Audience -> ActivityObject -> Circle -> Tie -> contact_id
        Tie.select { contact_id }
           .joins  { circle.activity_object.audiences }
           .where  { circle.activity_object.audiences.activity_id.eq(activity_id) }
           .flatten.uniq
      end

      def person_in_circle?(parent_contact_id, child_contact_id)
        # ActivityObject.id = parent_contact_id
        # ActivityObject -> Circle -> Tie -> contact_id = child_contact_id
        ActivityObject.select { id }
                      .joins  { circles.ties }
                      .where  { id.eq(parent_contact_id) & circles.ties.contact_id.eq(child_contact_id) }
                      .first.present?
      end
    end
  end
end
