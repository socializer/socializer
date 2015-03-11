#
# Namespace for the Socializer engine
#
module Socializer
  class Audience < ActiveRecord::Base
    extend Enumerize

    enumerize :privacy, in:  %w(public circles limited), default: :public, predicates: true, scope: true

    attr_accessible :activity_id, :privacy

    # Relationships
    belongs_to :activity, inverse_of: :audiences
    belongs_to :activity_object, inverse_of: :audiences

    # Validations
    # validates :activity_id, presence: true, uniqueness: { scope: :activity_object_id }
    validates :privacy, presence: true

    # Named Scopes
    scope :by_activity_id, -> id { where(activity_id: id) }

    # Class Methods

    # Instance Methods
    def object
      activity_object.activitable
    end
  end
end
