module Socializer
  class PersonAddress < ActiveRecord::Base
    extend Enumerize

    enumerize :category, in: { home: 1, work: 2 }, default: :home, predicates: true, scope: true

    attr_accessible :line1, :line2, :city, :postal_code_or_zip, :province_or_state, :country

    # Relationships
    belongs_to :person
  end
end
