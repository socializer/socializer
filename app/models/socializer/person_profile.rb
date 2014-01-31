module Socializer
  class PersonProfile < ActiveRecord::Base
    attr_accessible :label, :url

    # Relationships
    belongs_to :person

    # Validations
    validates :label, presence: true
    validates :url, presence: true
  end
end
