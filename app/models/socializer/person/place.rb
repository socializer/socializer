# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Place model
    #
    # Where the {Socializer::Person person} has lived
    #
    class Place < ApplicationRecord
      attr_accessible :city_name, :current

      # Relationships
      belongs_to :person

      # Validations
      validates :city_name, presence: true
      validates :person, presence: true

      # Named Scopes
      scope :current, -> { where(current: true) }
      scope :previous, -> { where(current: false) }
    end
  end
end
