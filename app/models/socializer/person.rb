require 'digest/md5'

module Socializer
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
    def self.audience_list(query)
      return if query.blank?
      @people ||= select(:display_name).guids.where(arel_table[:display_name].matches("%#{query}%"))
    end

    # Instance Methods
    def services
      @services ||= authentications.where.not(provider: 'Identity')
    end

    def circles
      @circles ||= activity_object.circles
    end

    def comments
      @comments ||= activity_object.comments
    end

    def notes
      @notes ||= activity_object.notes
    end

    def groups
      @groups ||= activity_object.groups
    end

    def memberships
      @memberships ||= activity_object.memberships
    end

    def received_notifications
      @notifications ||= activity_object.notifications
    end

    def contacts
      @contacts ||= circles.map { |c| c.contacts }.flatten.uniq
    end

    def contact_of
      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # @contact_of ||= Circle.joins(:ties).where(ties: { contact_id: guid }).map { |circle| circle.author }.uniq
      @contact_of ||= Circle.joins(:ties).where(socializer_ties: { contact_id: guid }).map { |circle| circle.author }.uniq
    end

    def likes
      verbs_of_interest = %w(like unlike)
      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # query = Activity.joins(:verb).where(actor_id: activity_object.id).where(target_id: nil).where(verb: { name: verbs_of_interest })
      query = Activity.joins(:verb).where(actor_id: activity_object.id).where(target_id: nil).where(socializer_verbs: { name: verbs_of_interest })
      # Alternate syntax:
      # query = Activity.joins(:verb).where(actor_id: activity_object.id).where(target_id: nil).where(verb: Verb.where(name: verbs_of_interest))
      @likes ||= query.group(:activity_object_id).having('COUNT(1) % 2 == 1')
    end

    def likes?(object)
      verbs_of_interest = %w(like unlike)
      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # query = Activity.joins(:verb).where(activity_object_id: object.id).where(actor_id: activity_object.id).where(verb: { name: verbs_of_interest })
      query = Activity.joins(:verb).where(activity_object_id: object.id).where(actor_id: activity_object.id).where(socializer_verbs: { name: verbs_of_interest })
      # Alternate syntax:
      # query = Activity.joins(:verb).where(activity_object_id: object.id).where(actor_id: activity_object.id).where(verb: Verb.where(name: verbs_of_interest))
      query.count.odd?
    end

    def pending_memberships_invites
      privacy_private = Group.privacy_level.find_value(:private).value
      # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
      # @pending_memberships_invites ||= Membership.joins(:group).where(member_id: guid, active: false, group: { privacy_level: privacy_private })
      @pending_memberships_invites ||= Membership.joins(:group).where(member_id: guid, active: false, socializer_groups: { privacy_level: privacy_private })
      # @pending_memberships_invites ||= Membership.joins(:group).where(member_id: guid, active: false, group: Group.where(privacy_level: privacy_private))
    end

    def avatar_url
      avatar_provider_array = %w( FACEBOOK LINKEDIN TWITTER )

      if avatar_provider_array.include?(avatar_provider)
        social_avatar_url(avatar_provider.downcase)
      else
        gravatar_url
      end
    end

    def add_default_circle
      activity_object.circles.create!(name: 'Friends',       content: 'Your real friends, the ones you feel comfortable sharing private details with.')
      activity_object.circles.create!(name: 'Family',        content: 'Your close and extended family, with as many or as few in-laws as you want.')
      activity_object.circles.create!(name: 'Acquaintances', content: "A good place to stick people you've met but aren't particularly close to.")
      activity_object.circles.create!(name: 'Following',     content: "People you don't know personally, but whose posts you find interesting.")
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
