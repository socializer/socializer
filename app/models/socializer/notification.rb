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
        next unless person_in_circle?(t.contact_id, activity.activitable_actor.id)
        # If the contact has the author of the activity in one of his circle.
        create_notification(activity, t.contact_id)
      end
    end

    # Instance methods

    # Marks the notification as read
    #
    # @return [boolean]
    def read!
      update!(read: true)
    end

    # Is the notification unread?
    #
    # @return [boolean]
    def unread?
      !read
    end

    # Class methods - Private
    def self.create_notification(activity, contact_id)
      notification = Notification.new do |n|
        n.activity = activity
        n.activity_object = ActivityObject.find_by(id: contact_id)
      end

      notification.save!
    end
    private_class_method :create_notification

    # FIXME: Move to Tie or Activity
    def self.get_potential_contact_id(activity_id)
      # Activity -> Audience -> ActivityObject -> Circle -> Tie -> contact_id
      Tie.select(:contact_id)
         .joins(circle: { activity_object: :audiences })
         .where(socializer_audiences: { activity_id: activity_id })
         .flatten.uniq

      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # Tie.select(:contact_id)
      #    .joins(circle: { activity_object: :audiences })
      #    .where(circle: { activity_object: { audiences: { activity_id: activity_id } } })
      #    .flatten.uniq
    end
    private_class_method :get_potential_contact_id

    # FIXME: Move to ActivityObject or Circle
    def self.person_in_circle?(parent_contact_id, child_contact_id)
      # ActivityObject.id = parent_contact_id
      # ActivityObject -> Circle -> Tie -> contact_id = child_contact_id
      ActivityObject.select(:id)
                    .joins(circles: :ties)
                    .where(id: parent_contact_id, socializer_ties: { contact_id: child_contact_id })
                    .present?

      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # ActivityObject.select(:id)
      #               .joins(circles: :ties)
      #               .where(id: parent_contact_id, circles: { ties: { contact_id: child_contact_id } })
      #               .present?
    end
    private_class_method :person_in_circle?
  end
end
