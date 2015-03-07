#
# Namespace for the Socializer engine
#
module Socializer
  class Tie < ActiveRecord::Base
    attr_accessible :contact_id

    # Relationships
    belongs_to :circle, inverse_of: :ties
    belongs_to :activity_contact, class_name: 'ActivityObject', foreign_key: 'contact_id', inverse_of: :ties

    has_one :contact, through: :activity_contact, source: :activitable,  source_type: 'Socializer::Person'

    # Named Scopes
    scope :by_contact_id, -> contact_id { where(contact_id: contact_id) }
  end
end
