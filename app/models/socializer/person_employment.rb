module Socializer
  class PersonEmployment < ActiveRecord::Base
    attr_accessible :employer_name, :job_title, :started_on, :ended_on, :current, :job_description

    # Relationships
    belongs_to :person

    # Validations
    validates :person, presence: true
  end
end
