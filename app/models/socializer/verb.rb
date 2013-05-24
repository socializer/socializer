module Socializer
  class Verb < ActiveRecord::Base

    attr_accessible :name

    has_many :activities

    validates :name, :presence => true, uniqueness: true
  end
end
