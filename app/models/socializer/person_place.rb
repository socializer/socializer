module Socializer
  class PersonPlace < ActiveRecord::Base
    belongs_to :person

     attr_accessible :city_name, :current

    validates :city_name, presence: true
  end
end
