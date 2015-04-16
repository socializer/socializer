#
# Namespace for the Socializer engine
#
module Socializer
  class Membership < ActiveRecord::Base
    attr_accessible :group_id, :active, :activity_member

    # Relationships
    belongs_to :group, inverse_of: :memberships
    belongs_to :activity_member, class_name: 'ActivityObject', foreign_key: 'member_id', inverse_of: :memberships

    has_one :member, through: :activity_member, source: :activitable,  source_type: 'Socializer::Person'

    # Validations

    # Named Scopes
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :by_member_id, -> member_id { where(member_id: member_id) }

    # Class Methods

    # Instance Methods

    def confirm
      update(active: true)
    end
  end
end
