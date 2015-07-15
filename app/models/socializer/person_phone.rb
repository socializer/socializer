#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Person Phone model
  #
  # Phone numbers related to the {Socializer::Person person}
  #
  class PersonPhone < ActiveRecord::Base
    extend Enumerize

    enumerize :category, in: { home: 1, work: 2 }, default: :home,
                         predicates: true, scope: true

    attr_accessible :label, :number

    # Relationships
    belongs_to :person

    # Validations
    validates :category, presence: true
    validates :label, presence: true
    validates :number, presence: true
    validates :person, presence: true
  end
end
