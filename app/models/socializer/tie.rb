#
# Namespace for the Socializer engine
#
module Socializer
  # A {Socializer::Tie} is a link between a {Socializer::Circle} and a {Socializer::Person}
  class Tie < ActiveRecord::Base
    attr_accessible :contact_id

    # Relationships
    belongs_to :circle, inverse_of: :ties
    belongs_to :activity_contact, class_name: 'ActivityObject', foreign_key: 'contact_id', inverse_of: :ties

    has_one :contact, through: :activity_contact, source: :activitable,  source_type: 'Socializer::Person'

    # Validations
    validates :circle, presence: true
    validates :activity_contact, presence: true

    # Named Scopes
    scope :by_circle_id, -> circle_id { where(circle_id: circle_id) }
    scope :by_contact_id, -> contact_id { where(contact_id: contact_id) }
  end
end
