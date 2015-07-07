#
# Namespace for the Socializer engine
#
module Socializer
  # A textual response to another object
  class Comment < ActiveRecord::Base
    include ObjectTypeBase

    attr_accessible :content

    # Relationships
    belongs_to :activity_author, class_name: 'ActivityObject', foreign_key: 'author_id', inverse_of: :comments

    has_one :author, through: :activity_author, source: :activitable,  source_type: 'Socializer::Person'

    # Validations
    validates :activity_author, presence: true
    validates :content, presence: true
  end
end
