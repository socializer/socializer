#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Person Address model
  #
  # Addresses related to the {Socializer::Person person}
  #
  class PersonAddress < ActiveRecord::Base
    extend Enumerize

    enumerize :category, in: { home: 1, work: 2 },
                         default: :home, predicates: true, scope: true

    attr_accessible :line1, :line2, :city, :postal_code_or_zip,
                    :province_or_state, :country

    # Relationships
    belongs_to :person

    # Validations
    validates :category, presence: true
    validates :person, presence: true
  end
end
