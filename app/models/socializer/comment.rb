module Socializer
  class Comment < ActiveRecord::Base
    include Socializer::ObjectTypeBase

    attr_accessible :object_id, :content

    belongs_to :activity_author,           class_name: 'ActivityObject', foreign_key: 'author_id'
    belongs_to :activity_commented_object, class_name: 'ActivityObject', foreign_key: 'object_id'

    def author
      @author ||= activity_author.activitable
    end

    def commented_object
      @commented_object ||= activity_commented_object.activitable
    end

  end
end
