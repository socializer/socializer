# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Verb model
  #
  # Identifies the action that the activity describes.
  class Verb < ApplicationRecord
    # Relationships
    has_many :activities, inverse_of: :verb, dependent: :destroy

    # Validations
    validates :display_name, presence: true, uniqueness: true

    # Named Scopes

    # Class Methods

    # Finds the verb with the given display name.
    #
    # @param name [String] the display name of the verb
    #
    # @return [ActiveRecord::Relation] the verbs with the given display name
    #
    # @example
    #   Socializer::Verb.with_display_name(name: 'like')
    def self.with_display_name(name:)
      where(display_name: name)
    end
  end
end
