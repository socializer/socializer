module Socializer
  class PersonEducation < ActiveRecord::Base
    belongs_to :person

    attr_accessible :school_name, :major_or_field_of_study, :start, :end, :current, :courses_description

  end
end
