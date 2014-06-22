#
# Namespace for the Socializer engine
#
module Socializer
  class ActivityField < ActiveRecord::Base
    attr_accessible :content, :activity

    belongs_to :activity, inverse_of: :activity_field

    validates :content,  presence: true
    validates :activity, presence: true
  end
end
