# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Group model
  class Group
    # Group Category model
    #
    # Categories guide discussions and help members find the topics they're most
    # interested in.
    class Category < ApplicationRecord
      # Relationships
      belongs_to :group, inverse_of: :links

      # Validations
      validates :display_name, presence: true
    end
  end
end
