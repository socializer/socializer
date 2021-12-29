# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Education model
    #
    # Where the {Socializer::Person person} has gone to school
    #
    class Education < ApplicationRecord
      # Relationships
      belongs_to :person, inverse_of: :educations

      # Validations
      validates :school_name, presence: true
      validates :started_on, presence: true
    end
  end
end
