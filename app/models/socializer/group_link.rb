module Socializer
  class GroupLink < ActiveRecord::Base
    belongs_to :group

    attr_accessible :label, :url

    validates :label, presence: true
    validates :url, presence: true

  end
end
