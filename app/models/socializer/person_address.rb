module Socializer
  class PersonAddress < ActiveRecord::Base
    extend Enumerize

    enumerize :category, in: { home: 1, work: 2 }, default: :home, predicates: true, scope: true

    belongs_to :person

    attr_accessible :line1, :line2, :city, :postal_code_or_zip, :province_or_state, :country

  end
end
