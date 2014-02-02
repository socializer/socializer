module Socializer
  class Authentication < ActiveRecord::Base
    attr_accessible :provider, :uid, :image_url

    belongs_to :person

    before_destroy :make_sure_its_not_the_last_one

    private

    def make_sure_its_not_the_last_one
      if person.authentications.count == 1
        # FIXME: authentication - This is not be a good user experience.
        #       If the user clicks 'unbind' on their last authentication they will get an error.
        #       A flash notice should be set and the user should be able to continue on.
        fail 'Cannot delete the last authentication available.'
      end
    end
  end
end
