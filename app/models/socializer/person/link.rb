# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Link model
    #
    # URLs that are interesting to the {Socializer::Person person}
    #
    class Link < ApplicationRecord
      # Relationships
      belongs_to :person, inverse_of: :links

      # Validations
      validates :display_name, presence: true
      validates :url, presence: true
    end
  end
end
