module Socializer
  class Circle < ActiveRecord::Base
    include ObjectTypeBase

    attr_accessible :name, :content

    # Relationships
    belongs_to :activity_author,  class_name: 'ActivityObject', foreign_key: 'author_id'

    has_many   :ties
    has_many   :activity_contacts, through: :ties

    # Validations
    validates :name, presence: true, uniqueness: { scope: :author_id }

    # Class Methods
    def self.audience_list(current_user, query)
      @circles ||= current_user.circles.select(:name).guids
      return @circles if query.blank?
      @circles ||= @circles.where(Circle.arel_table[:name].matches("%#{query}%"))
    end

    # Instance Methods
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
