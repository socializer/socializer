#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Activity Field model
  #
  class ActivityField < ActiveRecord::Base
    attr_accessible :content, :activity

    # Relationships
    belongs_to :activity, inverse_of: :activity_field

    # Validations
    validates :content,  presence: true
    validates :activity, presence: true
  end
end
