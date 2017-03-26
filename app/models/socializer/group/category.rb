# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Group model
  class Group
    #
    # Group Category model
    #
    # Categories guide discussions and help members find the topics they're most
    # interested in.
    #
    class Category < ApplicationRecord
      attr_accessible :display_name

      # Relationships
      belongs_to :group

      # Validations
      validates :group, presence: true
      validates :display_name, presence: true
    end
  end
end
