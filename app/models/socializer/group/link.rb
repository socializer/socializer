# frozen_string_literal: true

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
    class Link < ApplicationRecord
      # Relationships
      belongs_to :group

      # Validations
      validates :group, presence: true
      validates :display_name, presence: true
      validates :url, presence: true
    end
  end
end
