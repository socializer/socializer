#
# Namespace for the Socializer engine
#
module Socializer
  class Group < ActiveRecord::Base
    extend Enumerize
    include ObjectTypeBase

    enumerize :privacy, in: { public: 1, restricted: 2, private: 3 }, default: :public, predicates: true, scope: true

    attr_accessible :display_name, :privacy, :author_id

    # Relationships
    belongs_to :activity_author,  class_name: 'ActivityObject', foreign_key: 'author_id'

    has_many :memberships
    has_many :activity_members, -> { where(socializer_memberships: { active: true }) }, through: :memberships
    has_many :links, class_name: 'GroupLink', foreign_key: 'group_id', dependent: :destroy
    has_many :categories, class_name: 'GroupCategory', foreign_key: 'group_id', dependent: :destroy

    # Validations
    validates :activity_author, presence: true
    validates :display_name, presence: true, uniqueness: { scope: :author_id, case_sensitive: false }
    validates :privacy, presence: true

    # Callbacks
    after_create   :add_author_to_members
    before_destroy :deny_delete_if_members

    # Named Scopes

    # Class Methods

    # This method is a shorthand for the enumerize find_value(value).value method(s)
    #
    # @param privacy: [String]
    # @param privacy: [Symbol]
    #
    # @return [FixNum]
    def self.privacy_value(privacy:)
      self.privacy.find_value(privacy).value
    end

    # Return all groups with a privacy of public
    #
    # @return [ActiveRecord::Relation]
    def self.public
      Group.with_privacy(:public)
    end

    # Return all groups with a privacy of restricted
    #
    # @return [ActiveRecord::Relation]
    def self.restricted
      Group.with_privacy(:restricted)
    end

    # Return all groups with a privacy of private
    #
    # @return [ActiveRecord::Relation]
    def self.private
      Group.with_privacy(:private)
    end

    # Return all groups with a privacy of public or restricted
    #
    # @return [ActiveRecord::Relation]
    def self.joinable
      Group.with_privacy(:public, :restricted)
    end

    # Instance Methods
    def author
      @author ||= activity_author.activitable
    end

    def members
      @members ||= activity_members.map { |em| em.activitable }
    end

    def join(person)
      if privacy.public?
        active = true
      elsif privacy.restricted?
        active = false
      else
        fail 'Cannot self-join a private group, you need to be invited'
      end

      person.memberships.create!(group_id: id, active: active)
    end

    def invite(person)
      person.memberships.create!(group_id: id, active: false)
    end

    def leave(person)
      membership = person.memberships.find_by(group_id: id)
      membership.destroy
    end

    def member?(person)
      person.memberships.find_by(group_id: id).present?
    end

    private

    def add_author_to_members
      author.memberships.create!(group_id: id, active: true)
    end

    def deny_delete_if_members
      return unless memberships.count > 0
      fail 'Cannot delete a group that has members in it.'
    end
  end
end
