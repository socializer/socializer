module Socializer
  class GroupCategory < ActiveRecord::Base
    belongs_to :group

    attr_accessible :name

    validates :name, presence: true

  end
end
