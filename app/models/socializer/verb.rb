#
# Namespace for the Socializer engine
#
module Socializer
  class Verb < ActiveRecord::Base
    attr_accessible :name

    # Relationships
    has_many :activities, inverse_of: :verb

    # Validations
    validates :name, presence: true, uniqueness: true
  end
end
