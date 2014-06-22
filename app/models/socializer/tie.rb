#
# Namespace for the Socializer engine
#
module Socializer
  class Tie < ActiveRecord::Base
    attr_accessible :contact_id

    belongs_to :circle
    belongs_to :activity_contact, class_name: 'ActivityObject', foreign_key: 'contact_id'

    def contact
      @contact ||= activity_contact.activitable
    end
  end
end
