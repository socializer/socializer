require 'digest/md5'

module Socializer
  class Person < ActiveRecord::Base
    extend Enumerize
    include Socializer::ObjectTypeBase

    # enumerize :avatar_provider, in: { twitter: 1, facebook: 2, linkedin: 3, gravatar: 4 }, default: :gravatar, predicates: true, scope: true

    attr_accessible :display_name, :email, :language, :avatar_provider, :tagline, :introduction, :bragging_rights,
                    :occupation, :skills, :gender, :looking_for_friends, :looking_for_dating, :looking_for_relationship,
                    :looking_for_networking, :birthdate, :relationship, :other_names

    enumerize :gender, in: { unknown: 0, female: 1, male: 2 }, default: :unknown, predicates: true, scope: true
    enumerize :relationship, in: { unknown: 0, single: 1, relationship: 2, engaged: 3, married: 4, complicated: 5, open: 6, widowed: 7, domestic: 8, civil: 9 }, default: :unknown, predicates: true, scope: true

    has_many :authentications
    has_many :notifications

    has_many :addresses, class_name: 'PersonAddress', foreign_key: 'person_id', dependent: :destroy
    has_many :contributions, class_name: 'PersonContribution', foreign_key: 'person_id', dependent: :destroy
    has_many :educations, class_name: 'PersonEducation', foreign_key: 'person_id', dependent: :destroy
    has_many :employments, class_name: 'PersonEmployment', foreign_key: 'person_id', dependent: :destroy
    has_many :links, class_name: 'PersonLink', foreign_key: 'person_id', dependent: :destroy
    has_many :phones, class_name: 'PersonPhone', foreign_key: 'person_id', dependent: :destroy
    has_many :places, class_name: 'PersonPlace', foreign_key: 'person_id', dependent: :destroy

    validates :avatar_provider, inclusion: %w( TWITTER FACEBOOK LINKEDIN GRAVATAR )

    def services
      @services ||= authentications.where { provider.not_eq('Identity') }
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
      @contact_of ||= Circle.joins { ties }.where { ties.contact_id.eq my { guid } }.map { |circle| circle.author }.uniq
    end

    def likes
      activity_obj_id = activity_object.id
      query  = Activity.joins { verb }.where { actor_id.eq(activity_obj_id) & target_id.eq(nil) & verb.name.in(['like', 'unlike']) }
      @likes ||= query.group { activity_object_id }.having("COUNT(1) % 2 == 1") # Need to convert having to squeel ... how do you use % in squeel?
    end

    # REFACTOR: It may make more sense to retreive the activity object where the verb is like or unlike order by updated_at desc limit 1
    def likes?(object)
      activity_obj_id = activity_object.id

      query   = Activity.joins { verb }.where { activity_object_id.eq(object.id) & actor_id.eq(activity_obj_id) }
      likes   = query.where { verb.name.eq('like') }
      unlikes = query.where { verb.name.eq('unlike') }

      # Can replace the 3 return statements, but always runs 2 queries
      # !(likes.present? && unlikes.present?)

      return false if likes.count == 0
      return false if likes.count == unlikes.count
      true
    end

    def pending_memberships_invites
      privacy_private = Group.privacy_level.find_value(:private).value
      @pending_memberships_invites ||= Membership.joins { group }.where { member_id.eq(my { guid }) & active.eq(false) & group.privacy_level.eq(privacy_private) }
    end

    # TODO: avatar_url - clean this up
    def avatar_url
      avatar_provider_array = %w( FACEBOOK LINKEDIN TWITTER )

      if avatar_provider_array.include?(avatar_provider)
        provider = avatar_provider.downcase
        authentications.where(provider: provider).first.try(:image_url)
      else
        return if email.blank?
        "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
      end

      # if avatar_provider == 'FACEBOOK'
      #   authentications.where(provider: 'facebook')[0].image_url if authentications.where(provider: 'facebook')[0].present?
      # elsif avatar_provider == 'TWITTER'
      #   authentications.where(provider: 'twitter')[0].image_url if authentications.where(provider: 'twitter')[0].present?
      # elsif avatar_provider == 'LINKEDIN'
      #   authentications.where(provider: 'linkedin')[0].image_url if authentications.where(provider: 'linkedin')[0].present?
      # else
      #   "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}" if email.present?
      # end
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
  end
end
