#
# Namespace for the Socializer engine
#
module Socializer
  class Verb < ActiveRecord::Base
    attr_accessible :display_name

    # Relationships
    has_many :activities, inverse_of: :verb

    # Validations
    validates :display_name, presence: true, uniqueness: true

    # Named Scopes
    scope :by_name, -> name { where(name: name) }
  end
end
