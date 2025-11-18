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

    # Initialize a new AudienceList instance
    #
    # @param person [Socializer::Person] the person to build the list for
    # @param query [String, nil] Used to filter the audience list
    #
    # @return [AudienceList]
    #
    # @example
    #   Socializer::AudienceList.new(person: some_person, query: "example")
    def initialize(person:, query: nil)
      @person = person
      @query  = query

      raise(ArgumentError, errors.full_messages.to_sentence) unless valid?
    end

    # Class Methods

    # Class method to create and invoke an instance of AudienceList
    #
    # @param person [Socializer::Person] the person to build the list for
    # @param query [String, nil] Used to filter the audience list
    #
    # @return [Array] the audience list
    #
    # @example
    #   Socializer::AudienceList.call(person: some_person, query: "example")
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

    # Merge an icon into the provided list.
    #
    # If `list` is a Hash it will be merged with the `icon` key and returned.
    # If `list` is an Array or ActiveRecord::Relation each element will be
    # converted to a hash via `serializable_hash` and the `icon` key will be added.
    #
    # @param list [Array, ActiveRecord::Relation, Hash] the collection or hash to augment
    # @param icon [String] Icon identifier or CSS class to attach to each item (e.g. `fa-user`)
    #
    # @return [Hash, Array<Hash>] Returns a Hash when `list` is a Hash; otherwise returns an Array
    #   of Hashes with symbolized keys.
    #
    # @example
    #   merge_icon(list: { id: 1, name: 'Public' }, icon: 'fa-globe')
    #   # => { id: 1, name: 'Public', icon: 'fa-globe' }
    #
    #   merge_icon(list: Person.where(active: true), icon: 'fa-user')
    #   # => [{ id: 1, name: 'Alice', icon: 'fa-user' }, ...]
    def merge_icon(list:, icon:)
      return list.merge(icon:) if list.is_a?(Hash)

      list = list.to_a unless list.is_a?(Array)

      list.map do |item|
        item.serializable_hash.merge(icon:).symbolize_keys!
      end
    end

    # Build the list of people based on the query
    #
    # @return [ActiveRecord::Relation<Socializer::Person>] `Person.none` if @query is nil or empty,
    #   otherwise a relation containing matching persons (with display_name aliased to `name` and guids)
    def person_list
      return Person.none if @query.blank?

      result = select_display_name_alias_and_guids(query: Person)

      result.display_name_like(query: "%#{@query}%")
    end

    # Returns a {Hash} containing the value and text for the privacy level
    #
    # @param  privacy_symbol [Symbol] The symbol representing the Audience
    # privacy
    #
    # @return [Hash] Using the example you will get !{id: 1, name: "Public"}
    #
    # @example
    #   privacy_hash(privacy_symbol: :public)
    def privacy_hash(privacy_symbol:)
      privacy_symbol = privacy_symbol.downcase.to_sym
      privacy        = Audience.privacy.find_value(privacy_symbol)

      { id: privacy.value, name: privacy.text }
    end

    # Selects the `display_name` attribute aliased as `name` and ensures the query
    # includes GUIDs by applying the `guids` scope.
    #
    # @param query [ActiveRecord::Relation, Class] An ActiveRecord relation or model
    #   class. The method uses `query.base_class` and expects the relation to respond
    #   to `select` and the model to have a `display_name` column. Passing a model
    #   class (e.g. `Person`) or a relation (e.g. `Person.where(active: true)`) is
    #   supported.
    #
    # @return [ActiveRecord::Relation] The provided relation with `display_name` aliased
    #   to `name` and the `guids` scope applied.
    #
    # @example
    #   select_display_name_alias_and_guids(query: Person)
    #   # => SELECT people.display_name AS name, ... WITH guids scope applied
    def select_display_name_alias_and_guids(query:)
      klass              = query.base_class
      display_name_alias = klass.arel_table[:display_name].as("name")
      query.select(display_name_alias).guids
    end
  end
end
