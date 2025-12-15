# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Activity Field model
  class ActivityField < ApplicationRecord
    # Relationships
    belongs_to :activity, inverse_of: :activity_field

    # Validations
    validates :content, presence: true
  end
end
