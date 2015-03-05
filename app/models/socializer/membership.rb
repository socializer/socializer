#
# Namespace for the Socializer engine
#
module Socializer
  class Membership < ActiveRecord::Base
    attr_accessible :group_id, :active

    # Relationships
    belongs_to :group
    belongs_to :activity_member, class_name: 'ActivityObject', foreign_key: 'member_id'

    has_one :member, through: :activity_member, source: :activitable,  source_type: 'Socializer::Person'

    # Validations

    # Named Scopes
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :by_person, -> member_guid { where(member_id: member_guid) }

    # Class Methods

    # Instance Methods

    def approve!
      update_attribute(:active, true)
    end

    alias_method :confirm!, :approve!

    def decline!
      destroy
    end
  end
end
