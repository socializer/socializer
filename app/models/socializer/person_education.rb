module Socializer
  class PersonEducation < ActiveRecord::Base
    attr_accessible :school_name, :major_or_field_of_study, :started_on, :ended_on, :current, :courses_description

    # Relationships
    belongs_to :person

    # Validations
    validates :person, presence: true
  end
end
