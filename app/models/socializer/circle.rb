module Socializer
  class Circle < ActiveRecord::Base
    include Socializer::ObjectTypeBase

    attr_accessible :name, :description

    has_many   :ties
    has_many   :embedded_contacts, through: :ties

    belongs_to :embedded_author,  class_name: 'ActivityObject', foreign_key: 'author_id'

    def author
      @author ||= embedded_author.embeddable
    end

    def contacts
      @contacts ||= embedded_contacts.map { |ec| ec.embeddable }
    end

    def add_contact(contact_id)
      @tie = ties.build(contact_id: contact_id)
      @tie.save
    end

    def remove_contact(contact_id)
      @tie = ties.find_by(contact_id: contact_id)
      @tie.destroy
    end

  end
end
