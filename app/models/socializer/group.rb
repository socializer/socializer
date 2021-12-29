# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Group model
  #
  # A {Socializer::Group group} is a link between people where all members
  # share the same level of connection with each other.
  #
  class Group < ApplicationRecord
    extend Enumerize
    include ObjectTypeBase

    enumerize :privacy, in: { public: 1, restricted: 2, private: 3 },
                        default: :public, predicates: true, scope: true

    # Relationships
    belongs_to :activity_author, class_name: "ActivityObject",
                                 foreign_key: "author_id",
                                 inverse_of: :groups

    has_one :author, through: :activity_author,
                     source: :activitable,
                     source_type: "Socializer::Person",
                     dependent: :destroy

    has_many :links, class_name: "Group::Link",
                     dependent: :destroy,
                     inverse_of: :group

    has_many :categories, class_name: "Group::Category",
                          dependent: :destroy,
                          inverse_of: :group

    has_many :memberships, dependent: nil, inverse_of: :group

    has_many :activity_members,
             -> { merge(Membership.active) },
             through: :memberships

    has_many :members, through: :activity_members,
                       source: :activitable,
                       source_type: "Socializer::Person"

    # Validations
    validates :display_name, presence: true,
                             uniqueness: { scope: :author_id,
                                           case_sensitive: false }
    validates :privacy, presence: true

    # Callbacks
    after_create :add_author_to_members
    before_destroy :deny_delete_if_members

    # Named Scopes

    # Class Methods

    # Find groups where the display_name is equal to the given name
    #
    # @param name: [String]
    #
    # @return [Socializer::Group]
    def self.with_display_name(name:)
      where(display_name: name)
    end

    # Find all records where display_name is like "query"
    #
    # @param query: [String]
    #
    # @return [Socializer::Group]
    def self.display_name_like(query:)
      where(arel_table[:display_name].matches(query))
    end

    # Return all groups with a privacy of public
    #
    # @return [Socializer::Group]
    def self.public
      with_privacy(:public)
    end

    # Return all groups with a privacy of restricted
    #
    # @return [Socializer::Group]
    def self.restricted
      with_privacy(:restricted)
    end

    # Return all groups with a privacy of private
    #
    # @return [Socializer::Group]
    def self.private
      with_privacy(:private)
    end

    # Return all groups with a privacy of public or restricted
    #
    # @return [Socializer::Group]
    def self.joinable
      with_privacy(:public, :restricted)
    end

    # Instance Methods

    # Check if the person is a member of the group
    #
    # @param person [Socializer::Person] the person that you are checking
    #
    # @return [TrueClass/FalseClass]
    def member?(person)
      memberships.find_by(activity_member: person.activity_object).present?
    end

    private

    def add_author_to_members
      author.memberships.create!(group_id: id, active: true)
    end

    def deny_delete_if_members
      return if memberships.count.zero?

      message = I18n.t("socializer.errors.messages.group.still_has_members")
      errors.add(:base, message)

      throw(:abort)
    end
  end
end
