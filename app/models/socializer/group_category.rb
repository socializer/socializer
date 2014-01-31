module Socializer
  class GroupCategory < ActiveRecord::Base
    attr_accessible :name

    # Relationships
    belongs_to :group

    # Validations
    validates :name, presence: true
  end
end
