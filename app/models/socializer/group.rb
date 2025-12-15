# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Group model
  #
  # A {Socializer::Group group} is a link between people where all members
  # share the same level of connection with each other.
  class Group < ApplicationRecord
    extend Enumerize
    include ObjectTypeBase

    # FIXME: Rails 7.1.2 - remove the comment below.
    # TODO: Add a test for the normalizes method.
    # normalizes :display_name, with: lambda { |display_name|
    #                                   display_name.strip.titleize
    #                                 }

    # FIXME: Use Rails native enum instead of enumerize. Does the native enum
    #        method add inclusion validation?
    enumerize :privacy, in: { public: 1, restricted: 2, private: 3 },
                        default: :public, predicates: true, scope: true
    # enum :privacy, { public: 1, restricted: 2, private: 3 },
    #      default: :public, scopes: false
    # Stores values as strings instead of integers
    # enum :privacy, %i[public restricted private].index_by(&:itself),
    #      default: :public, scopes: false

    # Relationships
    belongs_to :activity_author, class_name: "Socializer::ActivityObject",
                                 foreign_key: "author_id",
                                 inverse_of: :groups

    has_one :author, through: :activity_author,
                     source: :activitable,
                     source_type: "Socializer::Person",
                     dependent: :destroy

    has_many :links, class_name: "Socializer::Group::Link",
                     dependent: :delete_all,
                     inverse_of: :group

    has_many :categories, class_name: "Socializer::Group::Category",
                          dependent: :delete_all,
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

    # Find groups with the specified display name
    #
    # @param name [String] the display name to search for
    #
    # @return [ActiveRecord::Relation<Socializer::Group>]
    #
    # @example
    #   Socializer::Group.with_display_name(name: "Example Group")
    def self.with_display_name(name:)
      where(display_name: name)
    end

    # Find groups where the display_name matches the given query pattern
    #
    # @param query [String] the pattern to match against display_name
    #
    # @return [ActiveRecord::Relation<Socializer::Group>]
    #
    # @example
    #   Socializer::Group.display_name_like(query: "%example%")
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
    # @return [Boolean]
    def member?(person)
      memberships.find_by(activity_member: person.activity_object).present?
    end

    private

    # Adds the group's author as an active member.
    # Called as an `after_create` callback to ensure the author is enrolled in the group.
    #
    # @return [Socializer::Membership] the created membership record
    #
    # @raise [ActiveRecord::RecordInvalid] if the membership cannot be created (uses `create!`)
    #
    # @example
    #   # After creating a group, the group's author will be added as a member
    #   group = Socializer::Group.create!(display_name: "Team", author: person)
    #   group.members.include?(person) # => true
    def add_author_to_members
      author.memberships.create!(group_id: id, active: true)
    end

    # Prevent destroying a group that still has members.
    #
    # This `before_destroy` callback adds an error on `:base` and halts the destroy
    # by throwing `:abort` when any memberships exist for the group.
    #
    # @return [void]
    #
    # @example
    #   # Attempting to destroy a group with members will be aborted:
    #   group = Socializer::Group.find(1)
    #   group.destroy # => false
    def deny_delete_if_members
      return if memberships.none?

      message = I18n.t("socializer.errors.messages.group.still_has_members")
      errors.add(:base, message)

      throw(:abort)
    end
  end
end
