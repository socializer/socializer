module Socializer
  class Group < ActiveRecord::Base
    extend Enumerize
    include ObjectTypeBase

    enumerize :privacy_level, in: { public: 1, restricted: 2, private: 3 }, default: :public, predicates: true, scope: true

    attr_accessible :name, :privacy_level, :author_id

    # Relationships
    belongs_to :activity_author,  class_name: 'ActivityObject', foreign_key: 'author_id'

    has_many :memberships
    has_many :activity_members, -> { where(socializer_memberships: { active: true }) }, through: :memberships
    has_many :links, class_name: 'GroupLink', foreign_key: 'group_id', dependent: :destroy
    has_many :categories, class_name: 'GroupCategory', foreign_key: 'group_id', dependent: :destroy

    # Validations
    validates :author_id, presence: true
    validates :name, presence: true, uniqueness: { scope: :author_id }
    validates :privacy_level, presence: true

    # Callbacks
    after_create   :add_author_to_members
    before_destroy :deny_delete_if_members

    # Named Scopes

    # Class Methods
    def self.audience_list(current_user, query)
      @groups ||= current_user.groups.select(:name).guids
      return @groups if query.blank?
      @groups  ||= @groups.where(Group.arel_table[:name].matches("%#{query}%"))
    end

    def self.public
      Group.with_privacy_level(:public)
    end

    def self.restricted
      Group.with_privacy_level(:restricted)
    end

    def self.private
      Group.with_privacy_level(:private)
    end

    def self.joinable
      Group.with_privacy_level(:public, :restricted)
    end

    # Instance Methods
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
      return unless memberships.count > 0
      fail 'Cannot delete a group that has members in it.'
    end
  end
end
