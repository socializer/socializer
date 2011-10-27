module Socializer
  class Authentication < ActiveRecord::Base
    
    belongs_to :person
    
    attr_accessible :provider, :uid
    
    before_destroy :make_sure_its_not_the_last_one
    
    def make_sure_its_not_the_last_one
      if person.authentications.count == 1
        raise "Cannot delete the last authentication available."
      end
    end
    
  end
end
