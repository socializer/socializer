module Socializer
  class Group < ActiveRecord::Base
    extend Enumerize
    include Socializer::ObjectTypeBase

    enumerize :privacy_level, in: { public: 1, restricted: 2, private: 3 }, default: :public, predicates: true, scope: true

    attr_accessible :name, :privacy_level

    belongs_to :activity_author,  class_name: 'ActivityObject', foreign_key: 'author_id'

    has_many :memberships
    has_many :activity_members, -> { where(socializer_memberships: { active: true }) }, through: :memberships

    validates :author_id, presence: true
    validates :name, presence: true, uniqueness: { scope: :author_id }
    validates :privacy_level, presence: true

    after_create   :add_author_to_members
    before_destroy :deny_delete_if_members

    scope :public, -> { where { privacy_level.eq(1) } }
    scope :restricted, -> { where { privacy_level.eq(2) } }
    scope :private, -> { where { privacy_level.eq(3) } }

    scope :joinable, -> { where { privacy_level.in([1, 2]) } }

    def author
      @author ||= activity_author.activitable
    end

    def members
      @members ||= activity_members.map { |em| em.activitable }
    end

    def join(person)
      @membership = person.memberships.build(group_id: id)

      if privacy_level.public?
        @membership.active = true
      elsif privacy_level.restricted?
        @membership.active = false
      else
        fail 'Cannot self-join a private group, you need to be invited'
      end

      @membership.save
    end

    def invite(person)
      @membership = person.memberships.build(group_id: id)

      @membership.active = false
      @membership.save
    end

    def leave(person)
      @membership = person.memberships.find_by(group_id: id)
      @membership.destroy
    end

    def member?(person)
      person.memberships.find_by(group_id: id).present?
    end

    private

    def add_author_to_members
      @membership = author.memberships.build(group_id: id)

      @membership.active = true
      @membership.save
    end

    def deny_delete_if_members
      if memberships.count > 0
        fail 'Cannot delete a group that has members in it.'
      end
    end
  end
end
