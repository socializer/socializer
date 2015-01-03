#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Note model
  #
  # Represents a short-form text message.
  #
  class Note < ActiveRecord::Base
    include ObjectTypeBase

    attr_accessible :content

    # Relationships
    belongs_to :activity_author, class_name: 'ActivityObject', foreign_key: 'author_id'

    # Validations
    validates :activity_author, presence: true
    validates :content, presence: true

    def author
      activity_author.activitable
    end
  end
end
