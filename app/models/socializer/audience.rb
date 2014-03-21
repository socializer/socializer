module Socializer
  class Audience < ActiveRecord::Base
    extend Enumerize

    enumerize :privacy_level, in: { public: 1, circles: 2, limited: 3 }, default: :public, predicates: true, scope: true

    attr_accessible :activity_id, :privacy_level

    belongs_to :activity
    belongs_to :activity_object

    # validates :activity_id, presence: true, uniqueness: { scope: :activity_object_id }
    validates :privacy_level, presence: true

    def object
      @object ||= activity_object.activitable
    end

    # Returns a [Hash] containing the value and text for the privacy level
    #
    # @example
    #   privacy_level_hash(:public)
    #
    # @param  privacy_symbol [Symbol] The symbol representing the Audience privacy_level
    #
    # @return [Hash] Using the example you will get {id: 1, name: 'Public'}
    def self.privacy_level_hash(privacy_symbol)
      privacy_symbol = privacy_symbol.downcase.to_sym
      privacy_level  = Socializer::Audience.privacy_level
      privacy        = privacy_level.find_value(privacy_symbol)

      { id: privacy.value, name: privacy.text }
    end
  end
end
