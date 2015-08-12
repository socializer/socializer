#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Person Employment model
  #
  # Where the {Socializer::Person person} has worked
  #
  class PersonEmployment < ActiveRecord::Base
    attr_accessible :employer_name, :job_title, :started_on, :ended_on,
                    :current, :job_description

    # Relationships
    belongs_to :person

    # Validations
    validates :person, presence: true
    validates :employer_name, presence: true
    validates :started_on, presence: true
  end
end
