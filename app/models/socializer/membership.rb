# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Membership model
  #
  # A {Socializer::Membership} is a link between a {Socializer::Group} and a
  # {Socializer::Person}
  #
  class Membership < ApplicationRecord
    # Relationships
    belongs_to :group, inverse_of: :memberships
    belongs_to :activity_member, class_name: "Socializer::ActivityObject",
                                 foreign_key: "member_id",
                                 inverse_of: :memberships

    has_one :member, through: :activity_member,
                     source: :activitable,
                     source_type: "Socializer::Person",
                     dependent: :destroy

    # Validations
    validates :active, inclusion: { in: [true, false] }, allow_nil: false

    # Named Scopes

    # Class Methods

    # Find memberships where active is true
    #
    # @return [ActiveRecord::Relation]
    def self.active
      where(active: true)
    end

    # Find memberships where active is false
    #
    # @return [ActiveRecord::Relation]
    def self.inactive
      where(active: false)
    end

    # Find memberships where the member_id is equal to the given member_id
    #
    # @param member_id: [Integer]
    #
    # @return [ActiveRecord::Relation]
    def self.with_member_id(member_id:)
      where(member_id:)
    end

    # Instance Methods
    def confirm
      update(active: true)
    end
  end
end
