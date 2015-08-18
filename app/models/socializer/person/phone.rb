#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Phone model
    #
    # Phone numbers related to the {Socializer::Person person}
    #
    class Phone < ActiveRecord::Base
      extend Enumerize

      enumerize :category, in: { home: 1, work: 2 }, default: :home,
                           predicates: true, scope: true

      enumerize :label, in: { phone: 1, mobile: 2, fax: 3 }, default: :phone,
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
end
