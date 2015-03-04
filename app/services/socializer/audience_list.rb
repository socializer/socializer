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
      # TODO: Add translation
      fail(ArgumentError, "person must be an instance of 'Socializer:Person' not '#{person.class.name}'") unless person.is_a?(Socializer::Person)

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
      audiences = []

      audiences << merge_icon(privacy_hash(:public), 'fa-globe')
      audiences << merge_icon(privacy_hash(:circles), 'fa-google-circles')

      # TODO: may use the avatar for the user
      audiences.concat(merge_icon(person_list, 'fa-user'))
      audiences.concat(merge_icon(audience_list(type: :circles), 'fa-google-circles'))
      audiences.concat(merge_icon(audience_list(type: :groups), 'fa-users'))
    end

    private

    # Build the audience list for @person with the passed in type and @query
    #
    # @param type [Symbol/String]
    #
    # @return [ActiveRecord::NullRelation] Person.none is returned if type is unknown
    # @return [ActiveRecord::AssociationRelation] Returns the name and guid of the passed in type
    def audience_list(type:)
      tableized_type = type.to_s.tableize
      return Person.none unless @person.respond_to?(tableized_type)

      query  = @person.public_send(tableized_type)
      result = select_display_name_alias_and_guids(query: query)

      return result if @query.blank?

      result.display_name_like(query: "%#{@query}%")
    end

    def merge_icon(list, icon)
      return list.merge(icon: icon) if list.is_a?(Hash)
      list = list.to_a unless list.is_a?(Array)
      list.map { |item| item.serializable_hash.merge(icon: icon).symbolize_keys! }
    end

    # Build the list of people based on the query
    #
    # @return [ActiveRecord::NullRelation] If query is nil or '', Person.none is returned
    # @return [ActiveRecord::Relation] If a query is provided the display_name and guid
    # for all records that match the query
    def person_list
      return Person.none if @query.blank?
      result = select_display_name_alias_and_guids(query: Person)
      result.display_name_like(query: "%#{@query}%")
    end

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

    def select_display_name_alias_and_guids(query:)
      klass              = query.base_class
      display_name_alias = klass.arel_table[:display_name].as('name')
      query.select(display_name_alias).guids
    end
  end
end
