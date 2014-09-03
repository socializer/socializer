#
# Namespace for the Socializer engine
#
module Socializer
  class Circle < ActiveRecord::Base
    include ObjectTypeBase

    attr_accessible :display_name, :content

    # Relationships
    belongs_to :activity_author,  class_name: 'ActivityObject', foreign_key: 'author_id'

    has_many   :ties
    has_many   :activity_contacts, through: :ties

    # Validations
    validates :display_name, presence: true, uniqueness: { scope: :author_id, case_sensitive: false }

    # Class Methods

    # Find all records where display_name is like 'query'
    #
    # @param query: [String]
    #
    # @return [ActiveRecord::Relation]
    def self.display_name_like(query:)
      where(arel_table[:display_name].matches(query))
    end

    # Instance Methods
    def author
      @author ||= activity_author.activitable
    end

    def contacts
      @contacts ||= activity_contacts.map(&:activitable)
    end

    def add_contact(contact_id)
      ties.create!(contact_id: contact_id)
    end

    def remove_contact(contact_id)
      tie = ties.find_by(contact_id: contact_id)
      tie.destroy
    end
  end
end
