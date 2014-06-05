module Socializer
  class Audience < ActiveRecord::Base
    extend Enumerize

    enumerize :privacy_level, in: { public: 1, circles: 2, limited: 3 }, default: :public, predicates: true, scope: true

    attr_accessible :activity_id, :privacy_level

    # Relationships
    belongs_to :activity
    belongs_to :activity_object

    # Validations
    # validates :activity_id, presence: true, uniqueness: { scope: :activity_object_id }
    validates :privacy_level, presence: true

    # Class Methods
    def self.audience_list(current_user, query)
      people  = query.blank? ? [] : Person.audience_list(query)
      circles = Circle.audience_list(current_user, query)
      groups  = Group.audience_list(current_user, query)

      build_audience_list_array(OpenStruct.new(people: people, circles: circles, groups: groups))
    end

    # Returns a [Hash] containing the value and text for the privacy level
    #
    # @example
    #   privacy_level_hash(:public)
    #
    # @param  privacy_symbol [Symbol] The symbol representing the Audience privacy_level
    #
    # @return [Hash] Using the example you will get !{id: 1, name: 'Public'}
    def self.privacy_level_hash(privacy_symbol)
      privacy_symbol = privacy_symbol.downcase.to_sym
      privacy_level  = Socializer::Audience.privacy_level
      privacy        = privacy_level.find_value(privacy_symbol)

      { id: privacy.value, name: privacy.text }
    end

    # Instance Methods
    def object
      @object ||= activity_object.activitable
    end

    # Class Methods - Private
    def self.build_audience_list_array(audience_list)
      audiences = []

      audiences << Audience.privacy_level_hash(:public)
      audiences << Audience.privacy_level_hash(:circles)
      audiences.concat(audience_list.people)
      audiences.concat(audience_list.circles)
      audiences.concat(audience_list.groups)
    end
    private_class_method :build_audience_list_array
  end
end
