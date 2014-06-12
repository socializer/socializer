module Socializer
  class PersonEmployment < ActiveRecord::Base
    attr_accessible :employer_name, :job_title, :started_on, :end, :current, :job_description

    # Relationships
    belongs_to :person
  end
end
