# frozen_string_literal: true
#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Contribution model
    #
    # Links to content that {Socializer::Person person} has contributed to
    #
    class Contribution < ApplicationRecord
      extend Enumerize

      enumerize :label, in: { current_contributor: 1, past_contributor: 2 },
                        default: :current_contributor, predicates: true,
                        scope: true

      attr_accessible :display_name, :label, :url, :current

      # Relationships
      belongs_to :person

      # Validations
      validates :display_name, presence: true
      validates :label, presence: true
      validates :person, presence: true
      validates :url, presence: true
    end
  end
end
