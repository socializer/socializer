module Socializer
  class PersonContribution < ActiveRecord::Base
    attr_accessible :label, :url, :current

    # Relationships
    belongs_to :person

    # Validations
    validates :label, presence: true
    validates :person, presence: true
    validates :url, presence: true
  end
end
