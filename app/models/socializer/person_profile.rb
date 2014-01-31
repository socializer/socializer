module Socializer
  class PersonProfile < ActiveRecord::Base
    belongs_to :person

    attr_accessible :label, :url

    validates :label, presence: true
    validates :url, presence: true

  end
end
