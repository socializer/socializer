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
    def self.audience_list(current_user, query)
      people  = query.blank? ? [] : Person.audience_list(query)
      circles = current_user.audience_list(:circles, query)
      groups  = current_user.audience_list(:groups, query)

      build_audience_list_array(OpenStruct.new(people: people, circles: circles, groups: groups))
    end

    # Returns a [Hash] containing the value and text for the privacy level
    #
    # @example
    #   privacy_hash(:public)
    #
    # @param  privacy_symbol [Symbol] The symbol representing the Audience privacy
    #
    # @return [Hash] Using the example you will get !{id: 1, name: 'Public'}
    def self.privacy_hash(privacy_symbol)
      privacy_symbol = privacy_symbol.downcase.to_sym
      privacy        = Audience.privacy.find_value(privacy_symbol)

      { id: privacy.value, name: privacy.text }
    end

    # Instance Methods
    def object
      @object ||= activity_object.activitable
    end

    # Class Methods - Private
    def self.build_audience_list_array(audience_list)
      audiences = []

      audiences << Audience.privacy_hash(:public)
      audiences << Audience.privacy_hash(:circles)
      audiences.concat(audience_list.people)
      audiences.concat(audience_list.circles)
      audiences.concat(audience_list.groups)
    end
    private_class_method :build_audience_list_array
  end
end
