#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Build the audience list that is used in the notes and shares forms
  #
  class AudienceList
    # Initializer
    #
    # @param person: [Socializer:Person] the person to build the list for
    # @param query: nil [String] Used to filter the audience list.
    #
    # @return [Socializer:AudienceList] returns an instance of AudienceList
    def initialize(person:, query: nil)
      fail(ArgumentError, 'person can not be blank') if person.blank?

      @person = person
      @query  = query
    end

    # Class Methods

    # Create the audience list
    #
    # @param person: [Socializer:Person] the person to build the list for
    # @param query: nil [String] Used to filter the audience list.
    #
    # @return [Array]
    def self.perform(person:, query: nil)
      AudienceList.new(person: person, query: query).perform
    end

    # Instance Methods

    # Create the audience list
    #
    # @return [Array]
    def perform
      # "Hello #{@person.display_name} with query '#{@query}'"
      people  = @query.blank? ? [] : Person.audience_list(@query)
      circles = @person.audience_list(:circles, @query)
      groups  = @person.audience_list(:groups, @query)

      build_audience_list_array(people: people, circles: circles, groups: groups)
    end

    private

    # Returns a {Hash} containing the value and text for the privacy level
    #
    # @example
    #   privacy_hash(:public)
    #
    # @param  privacy_symbol [Symbol] The symbol representing the Audience privacy
    #
    # @return [Hash] Using the example you will get !{id: 1, name: 'Public'}
    def privacy_hash(privacy_symbol)
      privacy_symbol = privacy_symbol.downcase.to_sym
      privacy        = Audience.privacy.find_value(privacy_symbol)

      { id: privacy.value, name: privacy.text }
    end

    def build_audience_list_array(people:, circles:, groups:)
      audiences = []

      audiences << merge_icon(privacy_hash(:public), 'fa-globe')
      audiences << merge_icon(privacy_hash(:circles), 'fa-google-circles')

      # TODO: may use the avatar for the user
      audiences.concat(merge_icon(people, 'fa-user'))
      audiences.concat(merge_icon(circles, 'fa-google-circles'))
      audiences.concat(merge_icon(groups, 'fa-users'))
    end

    def merge_icon(list, icon)
      return list.merge(icon: icon) if list.is_a?(Hash)
      list = list.to_a unless list.is_a?(Array)
      list.map { |item| item.serializable_hash.merge(icon: icon) }
    end
  end
end
