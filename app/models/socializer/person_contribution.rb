module Socializer
  class PersonContribution < ActiveRecord::Base
    belongs_to :person

    attr_accessible :label, :url, :current

    validates :label, presence: true
    validates :url, presence: true

  end
end
