#
# Namespace for the Socializer engine
#
module Socializer
  class Audience < ActiveRecord::Base
    extend Enumerize

    enumerize :privacy, in:  %w(public circles limited), default: :public, predicates: true, scope: true

    attr_accessible :activity_id, :privacy

    # Relationships
    belongs_to :activity
    belongs_to :activity_object

    # Validations
    # validates :activity_id, presence: true, uniqueness: { scope: :activity_object_id }
    validates :privacy, presence: true

    # Class Methods

    # This method is a shorthand for the enumerize find_value(value).value method(s)
    #
    # @param privacy: [String]
    # @param privacy: [Symbol]
    #
    # @return [String]
    def self.privacy_value(privacy:)
      self.privacy.find_value(privacy).value
    end

    # Instance Methods
    def object
      @object ||= activity_object.activitable
    end
  end
end
