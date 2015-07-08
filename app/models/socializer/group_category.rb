#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Group Category model
  #
  # Categories guide discussions and help members find the topics they're most
  # interested in.
  #
  class GroupCategory < ActiveRecord::Base
    attr_accessible :display_name

    # Relationships
    belongs_to :group

    # Validations
    validates :group, presence: true
    validates :display_name, presence: true
  end
end
