module Socializer
  class PersonEducation < ActiveRecord::Base
    attr_accessible :school_name, :major_or_field_of_study, :started_on, :end, :current, :courses_description

    # Relationships
    belongs_to :person
  end
end
