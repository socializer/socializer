# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Employment model
    #
    # Where the {Socializer::Person person} has worked
    #
    class Employment < ApplicationRecord
      # Relationships
      belongs_to :person, inverse_of: :employments

      # Validations
      validates :employer_name, presence: true
      validates :started_on, presence: true
    end
  end
end
