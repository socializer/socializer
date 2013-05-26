module Socializer
  class Verb < ActiveRecord::Base

    attr_accessible :name

    has_many :activities, inverse_of: :verb

    validates :name, :presence => true, uniqueness: true
  end
end
