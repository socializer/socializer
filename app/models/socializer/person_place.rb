#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Person Place model
  #
  # Where the {Socializer::Person person} has lived
  #
  class PersonPlace < ActiveRecord::Base
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
