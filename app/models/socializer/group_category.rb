#
# Namespace for the Socializer engine
#
module Socializer
  class GroupCategory < ActiveRecord::Base
    attr_accessible :display_name

    # Relationships
    belongs_to :group

    # Validations
    validates :group, presence: true
    validates :display_name, presence: true
  end
end
