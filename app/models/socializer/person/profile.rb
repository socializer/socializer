# frozen_string_literal: true
#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Profile model
    #
    # Links to other profiles that the {Socializer::Person person} has.
    # For example: Twitter, Facebook, etc.
    #
    class Profile < ActiveRecord::Base
      attr_accessible :display_name, :url

      # Relationships
      belongs_to :person

      # Validations
      validates :display_name, presence: true
      validates :person, presence: true
      validates :url, presence: true
    end
  end
end
