module Socializer
  class Notification < ActiveRecord::Base

    attr_accessible :displayed, :read

    # Relationships
    belongs_to :activity
    belongs_to :person

    # Validations
    validates_presence_of :activity_id
    validates_presence_of :person_id

  end
end
