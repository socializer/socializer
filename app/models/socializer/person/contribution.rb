# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    # Person Contribution model
    #
    # Links to content that {Socializer::Person person} has contributed to
    class Contribution < ApplicationRecord
      enum :label, { current_contributor: 1, past_contributor: 2 },
           default: :current_contributor, prefix: true, validate: { allow_nil: false }

      # Relationships
      belongs_to :person, inverse_of: :contributions

      # Validations
      validates :current, inclusion: { in: [true, false] }, allow_nil: false
      validates :display_name, presence: true
      validates :url, presence: true
    end
  end
end
