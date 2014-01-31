module Socializer
  class PersonPhone < ActiveRecord::Base
    extend Enumerize

    enumerize :category, in: { home: 1, work: 2 }, default: :home, predicates: true, scope: true

    belongs_to :person

    attr_accessible :label, :number

    validates :label, presence: true
    validates :number, presence: true

  end
end
