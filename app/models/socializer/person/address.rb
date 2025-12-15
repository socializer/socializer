# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    # Person Address model
    #
    # Addresses related to the {Socializer::Person person}
    class Address < ApplicationRecord
      extend Enumerize

      enumerize :category, in: { home: 1, work: 2 },
                           default: :home, predicates: true, scope: true

      # Relationships
      belongs_to :person, inverse_of: :addresses

      # Validations
      validates :category, presence: true
      validates :line1, presence: true
      validates :city, presence: true
      validates :province_or_state, presence: true
      validates :postal_code_or_zip, presence: true
      validates :country, presence: true
    end
  end
end
