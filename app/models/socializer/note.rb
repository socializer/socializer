# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Note model
  #
  # Represents a short-form text message.
  class Note < ApplicationRecord
    include ObjectTypeBase

    # Relationships
    belongs_to :activity_author, class_name: "Socializer::ActivityObject",
                                 foreign_key: "author_id",
                                 inverse_of: :notes

    has_one :author, through: :activity_author,
                     source: :activitable,
                     source_type: "Socializer::Person",
                     dependent: :destroy

    # Validations
    validates :content, presence: true
  end
end
