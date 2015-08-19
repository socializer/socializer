#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Group model
  class Group
    #
    # Group Link model
    #
    # URLs related to the {Socializer::Group group}
    #
    class Link < ActiveRecord::Base
      attr_accessible :label, :url

      # Relationships
      belongs_to :group

      # Validations
      validates :group, presence: true
      validates :label, presence: true
      validates :url, presence: true
    end
  end
end
