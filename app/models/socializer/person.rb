require 'digest/md5'

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Person model
  #
  # Represents an individual person.
  #
  class Person < ActiveRecord::Base
    extend Enumerize
    include ObjectTypeBase

    # enumerize :avatar_provider, in: { twitter: 1, facebook: 2, linkedin: 3, gravatar: 4 },
    #                             default: :gravatar, predicates: true, scope: true

    attr_accessible :display_name, :email, :language, :avatar_provider, :tagline, :introduction, :bragging_rights,
                    :occupation, :skills, :gender, :looking_for_friends, :looking_for_dating, :looking_for_relationship,
                    :looking_for_networking, :birthdate, :relationship, :other_names

    enumerize :gender, in: { unknown: 0, female: 1, male: 2 }, default: :unknown, predicates: true, scope: true
    enumerize :relationship, in: { unknown: 0,
                                   single: 1,
                                   relationship: 2,
                                   engaged: 3,
                                   married: 4,
                                   complicated: 5,
                                   open: 6,
                                   widowed: 7,
                                   domestic: 8,
                                   civil: 9 },
                             default: :unknown, predicates: true, scope: true

    # Relationships
    has_many :authentications
    has_many :addresses, class_name: 'PersonAddress', foreign_key: 'person_id', dependent: :destroy
    has_many :contributions, class_name: 'PersonContribution', foreign_key: 'person_id', dependent: :destroy
    has_many :educations, class_name: 'PersonEducation', foreign_key: 'person_id', dependent: :destroy
    has_many :employments, class_name: 'PersonEmployment', foreign_key: 'person_id', dependent: :destroy
    has_many :links, class_name: 'PersonLink', foreign_key: 'person_id', dependent: :destroy
    has_many :phones, class_name: 'PersonPhone', foreign_key: 'person_id', dependent: :destroy
    has_many :places, class_name: 'PersonPlace', foreign_key: 'person_id', dependent: :destroy
    has_many :profiles, class_name: 'PersonProfile', foreign_key: 'person_id', dependent: :destroy

    # Validations
    validates :avatar_provider, inclusion: %w( TWITTER FACEBOOK LINKEDIN GRAVATAR )

    # Named Scopes

    delegate :circles, to: :activity_object, allow_nil: true
    delegate :comments, to: :activity_object, allow_nil: true
    delegate :groups, to: :activity_object, allow_nil: true
    delegate :notes, to: :activity_object, allow_nil: true
    delegate :memberships, to: :activity_object, allow_nil: true

    # Class Methods

    # Creates a Socializer::Person with data provided by {https://github.com/intridea/omniauth/wiki OmniAuth}
    #
    # @param auth [Hash] Authentication information provided by {https://github.com/intridea/omniauth/wiki OmniAuth}.
    #
    # @see https://github.com/intridea/omniauth/wiki OmniAuth
    # @see https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema OmniAuth Auth Hash Schema
    #
    # @return [Socializer::Person]
    def self.create_with_omniauth(auth)
      auth_info = auth.info

      create! do |user|
        user.display_name = auth_info.name
        user.email = auth_info.email
        image_url = auth_info.image
        user.avatar_provider = image_url.blank? ? 'GRAVATAR' : auth.provider.upcase

        user.authentications.build(provider: auth.provider, uid: auth.uid, image_url: image_url)
      end
    end

    # Find all records where display_name is like 'query'
    #
    # @param query: [String]
    #
    # @return [ActiveRecord::Relation]
    def self.display_name_like(query:)
      where(arel_table[:display_name].matches(query))
    end

    # Instance Methods

    # Collection of {Socializer::Authentication authentications} that the user owns
    #
    # @return [Socializer::Authentication] Returns a collection of {Socializer::Authentication authentications}
    def services
      @services ||= authentications.by_not_provider('Identity')
    end

    # Collection of {Socializer::Notification notifications} that the user has received
    #
    # @return [Socializer::Notification] Returns a collection of {Socializer::Notification notifications}
    def received_notifications
      @notifications ||= activity_object.notifications.newest_first
    end

    # Collection of contacts for the user
    #
    # @return [Array] Returns a collection of contacts
    def contacts
      circles.flat_map(&:contacts).uniq
    end

    def contact_of
      # FIXME: Rails 5.0 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying
      #        joins/includes
      # @contact_of ||= Circle.joins(:ties).merge(Tie.by_contact_id(guid)).map(&:author).uniq
      @contact_of ||= Circle.joins(:ties).merge(Tie.by_contact_id(guid)).map(&:author).uniq
    end

    # A list of activities the user likes
    #
    # @example
    #   current_user.likes
    #
    # @return [ActiveRecord::Relation]
    def likes
      verbs_of_interest = %w(like unlike)

      query = Activity.joins(:verb)
                      .by_actor_id(guid)
                      .by_target_id(nil)
                      .merge(Verb.by_display_name(verbs_of_interest))

      @likes ||= query.group(:activity_object_id).having('COUNT(1) % 2 == 1')
    end

    # Checks if the person likes the object or not
    #
    # @example
    #   current_user.likes?(object)
    #
    # @param object [type]
    #
    # @return [TrueClass] if the person likes the object
    # @return [FalseClass] if the person does not like the object
    def likes?(object)
      verbs_of_interest = %w(like unlike)

      query = Activity.joins(:verb)
                      .by_activity_object_id(object.id)
                      .by_actor_id(guid)
                      .merge(Verb.by_display_name(verbs_of_interest))

      query.count.odd?
    end

    # Returns a collection of pending {Socializer::Membership memberships} invites
    #
    # @return [Socializer::Membership] Returns a collection of {Socializer::Membership memberships}
    def pending_memberships_invites
      @pending_memberships_invites ||= Membership.inactive.by_person(guid).joins(:group).merge(Group.private)
    end
  end
end
