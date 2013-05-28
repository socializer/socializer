module Socializer
  class ActivityField < ActiveRecord::Base
    attr_accessible :content, :activity

    belongs_to :activity

    validates :content,  :presence => true
    validates :activity, :presence => true
  end
end
