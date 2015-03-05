#
# Namespace for the Socializer engine
#
module Socializer
  class Comment < ActiveRecord::Base
    include ObjectTypeBase

    attr_accessible :content

    # Relationships
    belongs_to :activity_author, class_name: 'ActivityObject', foreign_key: 'author_id', inverse_of: :comments

    # Validations
    validates :activity_author, presence: true
    validates :content, presence: true

    def author
      activity_author.activitable
    end
  end
end
