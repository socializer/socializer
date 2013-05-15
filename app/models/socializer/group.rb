module Socializer
  class Group < ActiveRecord::Base
    include Socializer::ObjectTypeBase

    attr_accessible :name, :privacy_level

    validates :name, uniqueness: { scope: :author_id }
    validates_inclusion_of :privacy_level, in: %w( PUBLIC RESTRICTED PRIVATE )

    belongs_to :activity_author,  class_name: 'ActivityObject', foreign_key: 'author_id'

    has_many :memberships
    has_many :activity_members, -> { where(socializer_memberships: { active: true }) }, through: :memberships

    after_create   :add_author_to_members
    before_destroy :deny_delete_if_members

    def author
      @author ||= activity_author.activitable
    end

    def members
      @members ||= activity_members.map { |em| em.activitable }
    end

    def join (person)
      @membership = person.memberships.build(group_id: self.id)
      if self.privacy_level == 'PUBLIC'
        @membership.active = true
      elsif self.privacy_level == 'RESTRICTED'
        @membership.active = false
      else
        raise "Cannot self-join a private group, you need to be invited"
      end
      @membership.save
    end

    def invite(person)
      @membership = person.memberships.build(group_id: self.id)
      @membership.active = false
      @membership.save
    end

    def leave(person)
      @membership = person.memberships.find_by(group_id: self.id)
      @membership.destroy
    end

    def member?(person)
      person.memberships.find_by(group_id: self.id).present?
    end

    private

    def add_author_to_members
      @membership = author.memberships.build(group_id: self.id)
      @membership.active = true
      @membership.save
    end

    def deny_delete_if_members
      if memberships.count > 0
        raise "Cannot delete a group that has members in it."
      end
    end

  end
end
