#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Group Link model
  #
  # URLs related to the {Socializer::Group group}
  #
  class GroupLink < ActiveRecord::Base
    attr_accessible :label, :url

    # Relationships
    belongs_to :group

    # Validations
    validates :group, presence: true
    validates :label, presence: true
    validates :url, presence: true
  end
end
