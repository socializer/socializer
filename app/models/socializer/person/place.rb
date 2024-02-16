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
      # Relationships
      belongs_to :person, inverse_of: :places

      # Validations
      validates :city_name, presence: true

      # Named Scopes

      # Class Methods

      # Find places where current is true
      #
      # @return [ActiveRecord::Relation<Socializer::Person::Place>]
      def self.current
        where(current: true)
      end

      # Find places where current is false
      #
      # @return [ActiveRecord::Relation<Socializer::Person::Place>]
      def self.previous
        where(current: false)
      end
    end
  end
end
