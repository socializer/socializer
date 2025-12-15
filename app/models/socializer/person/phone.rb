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
      extend Enumerize

      enumerize :category, in: { home: 1, work: 2 }, default: :home,
                           predicates: true, scope: true

      enumerize :label, in: { phone: 1, mobile: 2, fax: 3 }, default: :phone,
                        predicates: true, scope: true

      # Relationships
      belongs_to :person, inverse_of: :phones

      # Validations
      validates :category, presence: true
      validates :label, presence: true
      validates :number, presence: true
    end
  end
end
