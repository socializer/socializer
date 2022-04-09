# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Build the audience list that is used in the notes and shares forms
  #
  class AudienceList
    include ActiveModel::Model
    include Utilities::Message

    attr_reader :person

    validates :person, presence: true, type: Socializer::Person

    # Initializer
    #
    # @param person: [Socializer::Person] the person to build the list for
    # @param query: nil [String] Used to filter the audience list.
    #
    # @return [Socializer::AudienceList] returns an instance of AudienceList
    def initialize(person:, query: nil)
      @person = person
      @query  = query

      raise(ArgumentError, errors.full_messages.to_sentence) unless valid?
    end

    # Class Methods

    # Invoke the AudienceList. This is the primary public API method.
    # Create the audience list
    #
    # @param person: [Socializer::Person] the person to build the list for
    # @param query: nil [String] Used to filter the audience list.
    #
    # @return [Array]
    def self.call(person:, query: nil)
      new(person:, query:).call
    end

    # Instance Methods

    # Invoke the AudienceList instance. This is the primary public API method.
    # Create the audience list
    #
    # @return [Array]
    # DISCUSS: Should this return a Set instead of an Array
    def call
      audiences = [merge_icon(list: privacy_hash(privacy_symbol: :public),
                              icon: "fa-globe")]

      audiences << merge_icon(list: privacy_hash(privacy_symbol: :circles),
                              icon: "fa-google-circles")

      # TODO: may use the avatar for the user
      audiences.concat(merge_icon(list: person_list, icon: "fa-user"))

      audiences.concat(merge_icon(list: audience_list(type: :circles),
                                  icon: "fa-google-circles"))

      audiences.concat(merge_icon(list: audience_list(type: :groups),
                                  icon: "fa-users"))
    end

    private

    # Build the audience list for @person with the passed in type and @query
    #
    # @param type [Symbol] or [String]
    #
    # @return [Socializer::Person] Person.none is returned if type is
    # unknown
    # @return [Socializer::Group] or [Socializer::Circle] Returns the name
    # and guid of the passed in type
    def audience_list(type:)
      tableized_type = type.to_s.tableize
      return Person.none unless @person.respond_to?(tableized_type)

      query  = @person.public_send(tableized_type)
      result = select_display_name_alias_and_guids(query:)

      return result if @query.blank?

      result.display_name_like(query: "%#{@query}%")
    end

    def merge_icon(list:, icon:)
      return list.merge(icon:) if list.is_a?(Hash)

      list = list.to_a unless list.is_a?(Array)

      list.map do |item|
        item.serializable_hash.merge(icon:).symbolize_keys!
      end
    end

    # Build the list of people based on the query
    #
    # @return [Socializer::Person] If query is nil or "", Person.none
    # is returned
    # @return [ActiveRecord::Relation] If a query is provided the display_name
    # and guid
    # for all records that match the query
    #
    # @return [Socializer::Person]
    def person_list
      return Person.none if @query.blank?

      result = select_display_name_alias_and_guids(query: Person)

      result.display_name_like(query: "%#{@query}%")
    end

    # Returns a {Hash} containing the value and text for the privacy level
    #
    # @example
    #   privacy_hash(privacy_symbol: :public)
    #
    # @param  privacy_symbol [Symbol] The symbol representing the Audience
    # privacy
    #
    # @return [Hash] Using the example you will get !{id: 1, name: "Public"}
    def privacy_hash(privacy_symbol:)
      privacy_symbol = privacy_symbol.downcase.to_sym
      privacy        = Audience.privacy.find_value(privacy_symbol)

      { id: privacy.value, name: privacy.text }
    end

    def select_display_name_alias_and_guids(query:)
      klass              = query.base_class
      display_name_alias = klass.arel_table[:display_name].as("name")
      query.select(display_name_alias).guids
    end
  end
end
