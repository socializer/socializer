#
# Namespace for the Socializer engine
#
module Socializer
  class Membership < ActiveRecord::Base
    attr_accessible :group_id

    # Relationships
    belongs_to :group
    belongs_to :activity_member, class_name: 'ActivityObject', foreign_key: 'member_id'

    def member
      @member ||= activity_member.activitable
    end

    def approve!
      update_attribute(:active, true)
    end

    alias_method :confirm!, :approve!

    def decline!
      destroy
    end
  end
end
