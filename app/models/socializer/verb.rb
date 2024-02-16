# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Verb model
  #
  # Identifies the action that the activity describes.
  #
  class Verb < ApplicationRecord
    # Relationships
    has_many :activities, inverse_of: :verb, dependent: :destroy

    # Validations
    validates :display_name, presence: true, uniqueness: true

    # Named Scopes

    # Class Methods

    # Find verbs where the display_name is equal to the given name
    #
    # @param name: [String]
    #
    # @return [ActiveRecord::Relation<Socializer::Verb>]
    def self.with_display_name(name:)
      where(display_name: name)
    end
  end
end
