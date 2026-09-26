# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    # Person Phone model
    #
    # Phone numbers related to the {Socializer::Person person}
    class Phone < ApplicationRecord
      enum :category, { home: 1, work: 2 },
           default: :home, prefix: true, validate: { allow_nil: false }

      enum :label, { phone: 1, mobile: 2, fax: 3 },
           default: :phone, prefix: true, validate: { allow_nil: false }

      # Relationships
      belongs_to :person, inverse_of: :phones

      # Validations
      validates :number, presence: true
    end
  end
end
