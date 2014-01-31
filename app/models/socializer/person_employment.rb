module Socializer
  class PersonEmployment < ActiveRecord::Base
    belongs_to :person

    attr_accessible :employer_name, :job_title, :start, :end, :current, :job_description

  end
end
