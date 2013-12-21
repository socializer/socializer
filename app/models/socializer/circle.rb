module Socializer
  class Circle < ActiveRecord::Base
    include Socializer::ObjectTypeBase

    attr_accessible :name, :content

    belongs_to :activity_author,  class_name: 'ActivityObject', foreign_key: 'author_id'

    has_many   :ties
    has_many   :activity_contacts, through: :ties

    validates :name, presence: true, uniqueness: { scope: :author_id }

    def author
      @author ||= activity_author.activitable
    end

    def contacts
      @contacts ||= activity_contacts.map { |ec| ec.activitable }
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
