# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Comment model
  #
  # A textual response to another object
  #
  class Comment < ApplicationRecord
    include ObjectTypeBase

    # Relationships
    belongs_to :activity_author, class_name: "ActivityObject",
                                 foreign_key: "author_id",
                                 inverse_of: :comments

    has_one :author, through: :activity_author,
                     source: :activitable,
                     source_type: "Socializer::Person",
                     dependent: :destroy

    # Validations
    validates :content, presence: true
  end
end
