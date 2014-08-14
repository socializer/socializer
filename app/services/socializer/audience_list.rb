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
      audiences = []

      audiences << merge_icon(privacy_hash(:public), 'fa-globe')
      audiences << merge_icon(privacy_hash(:circles), 'fa-google-circles')

      # TODO: may use the avatar for the user
      audiences.concat(merge_icon(person_list, 'fa-user'))
      audiences.concat(merge_icon(circle_list, 'fa-google-circles'))
      audiences.concat(merge_icon(group_list, 'fa-users'))
    end

    private

    # Build the list of groups based on the person and the query if present.
    #
    # @return [ActiveRecord::AssociationRelation] Returns the name and guid
    def circle_list
      result = @person.circles.select(Circle.arel_table[:display_name].as('name')).guids
      return result if @query.blank?

      result.display_name_like(query: "%#{@query}%")
    end

    # Build the list of groups based on the person and the query if present.
    #
    # @return [ActiveRecord::AssociationRelation] Returns the name and guid
    def group_list
      result = @person.groups.select(Group.arel_table[:display_name].as('name')).guids
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
      Person.select(Person.arel_table[:display_name].as('name')).guids
            .display_name_like(query: "%#{@query}%")
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
  end
end
