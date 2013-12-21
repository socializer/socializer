module Socializer
  class Membership < ActiveRecord::Base
    attr_accessible :group_id

    belongs_to :group
    belongs_to :activity_member, class_name: 'ActivityObject', foreign_key: 'member_id'

    def member
      @member ||= activity_member.activitable
    end

    def approve!
      self.update_attribute(:active, true)
    end

    def confirm!
      self.update_attribute(:active, true)
    end
  end
end
