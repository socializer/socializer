module Socializer
  class Note < ActiveRecord::Base
    include Socializer::ObjectTypeBase

    attr_accessible :content

    belongs_to :embedded_author, class_name: 'ActivityObject', foreign_key: 'author_id'

    def author
      @author ||= embedded_author.embeddable
    end

  end
end
