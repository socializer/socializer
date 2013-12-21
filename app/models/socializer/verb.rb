module Socializer
  class Verb < ActiveRecord::Base
    attr_accessible :name

    # FIXME: This shouldn't need the class name. See if it is fixed in Rails 4 RC2 or Final
    has_many :activities, class_name: 'Activity', inverse_of: :verb

    validates :name, presence: true, uniqueness: true
  end
end
