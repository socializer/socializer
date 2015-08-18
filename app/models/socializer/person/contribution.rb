#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Contribution model
    #
    # Links to content that {Socializer::Person person} has contributed to
    #
    class Contribution < ActiveRecord::Base
      attr_accessible :label, :url, :current

      # Relationships
      belongs_to :person

      # Validations
      validates :label, presence: true
      validates :person, presence: true
      validates :url, presence: true
    end
  end
end
