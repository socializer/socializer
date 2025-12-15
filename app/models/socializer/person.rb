# frozen_string_literal: true

require "digest/md5"

#
# Namespace for the Socializer engine
#
module Socializer
  # Person model
  #
  # Represents an individual {person Socializer::Person}.
  class Person < ApplicationRecord
    extend Enumerize
    include ObjectTypeBase

    # enumerize :avatar_provider, in: { twitter: 1, facebook: 2, linkedin: 3,
    #                                   gravatar: 4 },
    #                             default: :gravatar,
    #                             predicates: true, scope: true

    enumerize :gender, in: { unknown: 0, female: 1, male: 2 },
                       default: :unknown, predicates: true, scope: true

    enumerize :relationship, in: { unknown: 0, single: 1, relationship: 2,
                                   engaged: 3, married: 4, complicated: 5,
                                   open: 6, widowed: 7, domestic: 8, civil: 9 },
                             default: :unknown, predicates: true, scope: true

    # Relationships
    has_many :authentications, dependent: :destroy
    has_many :addresses, class_name: "Socializer::Person::Address",
                         dependent: :destroy, inverse_of: :person

    has_many :contributions, class_name: "Socializer::Person::Contribution",
                             dependent: :destroy, inverse_of: :person

    has_many :educations, class_name: "Socializer::Person::Education",
                          dependent: :delete_all, inverse_of: :person

    has_many :employments, class_name: "Socializer::Person::Employment",
                           dependent: :delete_all, inverse_of: :person

    has_many :links, class_name: "Socializer::Person::Link",
                     dependent: :delete_all, inverse_of: :person

    has_many :phones, class_name: "Socializer::Person::Phone",
                      dependent: :destroy, inverse_of: :person

    has_many :places, class_name: "Socializer::Person::Place",
                      dependent: :delete_all, inverse_of: :person

    has_many :profiles, class_name: "Socializer::Person::Profile",
                        dependent: :delete_all, inverse_of: :person

    # TODO: May be able replace the circles and contacts delegates. Should be
    #       able to create circles through this relationship
    # has_many :circles, through: :activity_object
    # has_many :contacts, through: :circles

    # Validations
    validates :avatar_provider, inclusion: %w[TWITTER FACEBOOK LINKEDIN
                                              GRAVATAR]

    validates :looking_for_friends, inclusion: { in: [true, false] },
                                    allow_nil: false

    validates :looking_for_dating, inclusion: { in: [true, false] },
                                   allow_nil: false

    validates :looking_for_relationship, inclusion: { in: [true, false] },
                                         allow_nil: false

    validates :looking_for_networking, inclusion: { in: [true, false] },
                                       allow_nil: false

    # Named Scopes

    delegate :circles, to: :activity_object, allow_nil: true
    delegate :comments, to: :activity_object, allow_nil: true
    delegate :contacts, to: :activity_object, allow_nil: true
    delegate :groups, to: :activity_object, allow_nil: true
    delegate :notes, to: :activity_object, allow_nil: true
    delegate :memberships, to: :activity_object, allow_nil: true
    delegate :count, to: :contacts, prefix: true, allow_nil: true

    # Class Methods

    # Creates a Socializer::Person with data provided by
    # {https://github.com/intridea/omniauth/wiki OmniAuth}
    #
    # @param auth [Hash] Authentication information provided by
    # {https://github.com/intridea/omniauth/wiki OmniAuth}.
    #
    # @see https://github.com/intridea/omniauth/wiki OmniAuth
    # @see https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema OmniAuth
    # Auth Hash Schema
    #
    # @return [Socializer::Person]
    def self.create_with_omniauth(auth)
      auth_info = auth.info
      auth_provider = auth.provider

      create!(display_name: auth_info.name, email: auth_info.email) do |user|
        image_url = auth_info.image
        avatar_provider = image_url.blank? ? "GRAVATAR" : auth_provider.upcase

        user.avatar_provider = avatar_provider

        user.authentications.build(provider: auth_provider,
                                   uid: auth.uid, image_url:)
      end
    end

    # Finds people whose display name matches the given query.
    #
    # @param query [String] The query string to match display names.
    #
    # @return [ActiveRecord::Relation<Socializer::Person>] A collection of people with matching display names.
    #
    # @example
    #   Socializer::Person.display_name_like(query: "%John%")
    def self.display_name_like(query:)
      where(arel_table[:display_name].matches(query))
    end

    # Instance Methods

    # Collection of {Socializer::Authentication authentications} that the user
    # owns
    #
    # @return [ActiveRecord::Relation<Socializer::Authentication>] Returns a
    #   collection of {Socializer::Authentication authentications}
    def services
      return @services if defined?(@services)

      @services = authentications.not_with_provider(provider: "Identity")
    end

    # Collection of {Socializer::Notification notifications} that the user has
    # received
    #
    # @return [Socializer::Notification] Returns a collection of
    #   {Socializer::Notification notifications}
    def received_notifications
      return @received_notifications if defined?(@received_notifications)

      @received_notifications = activity_object.notifications.newest_first
    end

    # A collection of {Socializer::Person people} this person is a contact of
    #
    # @return [Socializer::Person]
    def contact_of
      return @contact_of if defined?(@contact_of)

      @contact_of = Person.joins(activity_object: { circles: :ties })
                          .distinct
                          .merge(Tie.with_contact_id(contact_id: guid))
    end

    # A list of activities the user likes
    #
    # @return [Socializer::Activity]
    #
    # @example
    #   current_user.likes
    def likes
      return @likes if defined?(@likes)

      verbs_of_interest = %w[like unlike]

      query = Activity.joins(:verb)
                      .with_actor_id(id: guid)
                      .with_target_id(id: nil)
                      .merge(Verb.with_display_name(name: verbs_of_interest))

      @likes = query.group(:activity_object_id).having("COUNT(1) % 2 == 1")
    end

    # Checks if the person likes the object or not
    #
    # @param object [Socializer::ActivityObject]
    #
    # @return [TrueClass] if the person likes the object
    # @return [FalseClass] if the person does not like the object
    #
    # @example
    #   current_user.likes?(object)
    def likes?(object)
      verbs_of_interest = %w[like unlike]

      query = Activity.joins(:verb)
                      .with_activity_object_id(id: object.id)
                      .with_actor_id(id: guid)
                      .merge(Verb.with_display_name(name: verbs_of_interest))

      query.count.odd?
    end

    # Returns a collection of pending {Socializer::Membership memberships}
    # invites
    #
    # @return [Socializer::Membership] Returns a collection of
    # {Socializer::Membership memberships}
    def pending_membership_invites
      return @pending_membership_invites if defined?(@pending_membership_invites)

      @pending_membership_invites = Membership.joins(:group)
                                              .merge(Group.private)
                                              .inactive
                                              .with_member_id(member_id: guid)
    end
  end
end
