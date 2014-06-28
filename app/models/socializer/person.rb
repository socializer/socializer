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

    # enumerize :avatar_provider, in: { twitter: 1, facebook: 2, linkedin: 3, gravatar: 4 }, default: :gravatar, predicates: true, scope: true

    attr_accessible :display_name, :email, :language, :avatar_provider, :tagline, :introduction, :bragging_rights,
                    :occupation, :skills, :gender, :looking_for_friends, :looking_for_dating, :looking_for_relationship,
                    :looking_for_networking, :birthdate, :relationship, :other_names

    enumerize :gender, in: { unknown: 0, female: 1, male: 2 }, default: :unknown, predicates: true, scope: true
    enumerize :relationship, in: { unknown: 0, single: 1, relationship: 2, engaged: 3, married: 4, complicated: 5, open: 6, widowed: 7, domestic: 8, civil: 9 }, default: :unknown, predicates: true, scope: true

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

    # Class Methods

    # Used to build Audience.audience_list
    #
    # @example
    #   Person.audience_list(query)
    #
    # @param query [String] Used to filter the audience list
    #
    # @return [NilClass] If query is nil or '', nil is returned
    # @return [ActiveRecord::Relation] If a query is provided the display_name and guid for all records that match the query
    def self.audience_list(query)
      return if query.blank?
      # DISCUSS: Do we need display_name in the select?
      select(:display_name, 'display_name AS name').guids.where(arel_table[:display_name].matches("%#{query}%"))
    end

    def self.create_with_omniauth(auth)
      create! do |user|
        user.display_name = auth.info.name
        user.email = auth.info.email
        image_url = auth.info.image

        if image_url.nil?
          image_url = ''
          user.avatar_provider = 'GRAVATAR'
        else
          user.avatar_provider = auth.provider.upcase
        end

        user.authentications.build(provider: auth.provider, uid: auth.uid, image_url: image_url)
      end
    end

    # Instance Methods

    # [audience_list description]
    #
    # @example
    #   current_user.audience_list(:circles, nil)
    #   current_user.audience_list('circles', nil)
    #
    # @param type [Symbol/String] [description]
    # @param query [String] [description]
    #
    # @return [ActiveRecord::AssociationRelation] Returns the name and guid of the passed in type
    def audience_list(type, query)
      type = type.to_s.downcase.pluralize
      return unless respond_to?(type)

      result = send(type).select(:name).guids
      return result if query.blank?

      klass = "Socializer::#{type.classify}".constantize
      result.where(klass.arel_table[:name].matches("%#{query}%"))
    end

    # Collection of {Socializer:Authentication authentications} that the user owns
    #
    # @return [Socializer::Authentication] Returns a collection of authentications
    def services
      @services ||= authentications.where.not(provider: 'Identity')
    end

    # Collection of {Socializer:Circle circles} that the user owns
    #
    # @return [Socializer::Circle] Returns a collection of {Socializer:Circle circles}
    def circles
      @circles ||= activity_object.circles
    end

    # Collection of {Socializer:Comment comments} that the user owns
    #
    # @return [Socializer::Comment] Returns a collection of {Socializer:Comment comments}
    def comments
      @comments ||= activity_object.comments
    end

    # Collection of {Socializer:Note notes} that the user owns
    #
    # @return [Socializer::Note] Returns a collection of {Socializer:Note notes}
    def notes
      @notes ||= activity_object.notes
    end

    # Collection of {Socializer:Group groups} that the user owns
    #
    # @return [Socializer::Group] Returns a collection of {Socializer:Group groups}
    def groups
      @groups ||= activity_object.groups
    end

    # Collection of {Socializer::Membership memberships} that the user owns
    #
    # @return [Socializer::Membership] Returns a collection of {Socializer::Membership memberships}
    def memberships
      @memberships ||= activity_object.memberships
    end

    # Collection of {Socializer::Notification notifications} that the user has received
    #
    # @return [Socializer::Notification] Returns a collection of {Socializer::Notification notifications}
    def received_notifications
      @notifications ||= activity_object.notifications
    end

    # Collection of contacts for the user
    #
    # @return [Array] Returns a collection of contacts
    def contacts
      @contacts ||= circles.map { |c| c.contacts }.flatten.uniq
    end

    def contact_of
      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # @contact_of ||= Circle.joins(:ties).where(ties: { contact_id: guid }).map { |circle| circle.author }.uniq
      @contact_of ||= Circle.joins(:ties).where(socializer_ties: { contact_id: guid }).map { |circle| circle.author }.uniq
    end

    # A list of activities the user likes
    #
    # @example
    #   current_user.likes
    #
    # @return [ActiveRecord::Relation]
    def likes
      verbs_of_interest = %w(like unlike)
      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # query = Activity.joins(:verb).where(actor_id: activity_object.id).where(target_id: nil).where(verb: { name: verbs_of_interest })
      query = Activity.joins(:verb).where(actor_id: activity_object.id).where(target_id: nil).where(socializer_verbs: { name: verbs_of_interest })
      # Alternate syntax:
      # query = Activity.joins(:verb).where(actor_id: activity_object.id).where(target_id: nil).where(verb: Verb.where(name: verbs_of_interest))
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
      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # query = Activity.joins(:verb).where(activity_object_id: object.id).where(actor_id: activity_object.id).where(verb: { name: verbs_of_interest })
      query = Activity.joins(:verb).where(activity_object_id: object.id).where(actor_id: activity_object.id).where(socializer_verbs: { name: verbs_of_interest })
      # Alternate syntax:
      # query = Activity.joins(:verb).where(activity_object_id: object.id).where(actor_id: activity_object.id).where(verb: Verb.where(name: verbs_of_interest))
      query.count.odd?
    end

    # Returns a collection of pending {Socializer:Membership memberships} invites
    #
    # @return [Socializer::Membership] Returns a collection of {Socializer:Membership memberships}
    def pending_memberships_invites
      privacy_private = Group.privacy.find_value(:private).value
      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # @pending_memberships_invites ||= Membership.joins(:group).where(member_id: guid, active: false, group: { privacy: privacy_private })
      @pending_memberships_invites ||= Membership.joins(:group).where(member_id: guid, active: false, socializer_groups: { privacy: privacy_private })
      # @pending_memberships_invites ||= Membership.joins(:group).where(member_id: guid, active: false, group: Group.where(privacy: privacy_private))
    end

    # The location/url of the persons avatar
    #
    # @example
    #   current_user.avatar_url
    #
    # @return [String]
    def avatar_url
      avatar_provider_array = %w( FACEBOOK LINKEDIN TWITTER )

      if avatar_provider_array.include?(avatar_provider)
        social_avatar_url(avatar_provider.downcase)
      else
        gravatar_url
      end
    end

    # Add the default circles for the current person
    def add_default_circles
      activity_object.circles.create!(name: 'Friends',       content: 'Your real friends, the ones you feel comfortable sharing private details with.')
      activity_object.circles.create!(name: 'Family',        content: 'Your close and extended family, with as many or as few in-laws as you want.')
      activity_object.circles.create!(name: 'Acquaintances', content: "A good place to stick people you've met but aren't particularly close to.")
      activity_object.circles.create!(name: 'Following',     content: "People you don't know personally, but whose posts you find interesting.")
    end

    private

    def social_avatar_url(provider)
      authentication = authentications.find_by(provider: provider)
      authentication.image_url if authentication.present?
    end

    def gravatar_url
      return if email.blank?
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
    end
  end
end
