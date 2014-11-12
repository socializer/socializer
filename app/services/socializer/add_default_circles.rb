#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Add the default circles for the person
  #
  class AddDefaultCircles
    # Initializer
    #
    # @param person: [Socializer:Person] the person to build the list for
    # @param query: nil [String] Used to filter the audience list.
    #
    # @return [Socializer:AddDefaultCircles] returns an instance of AddDefaultCircles
    def initialize(person:)
      fail(ArgumentError, 'person can not be blank') if person.blank?

      @person = person
    end

    # Class Methods

    # Add the default circles
    #
    # @param person: [Socializer:Person] the person to create the default circles for
    def self.perform(person:)
      AddDefaultCircles.new(person: person).perform
    end

    # Instance Methods

    # Add the default circles
    def perform
      @person.circles.create!(display_name: 'Friends',
                              content: 'Your real friends, the ones you feel comfortable sharing private details with.')

      @person.circles.create!(display_name: 'Family',
                              content: 'Your close and extended family, with as many or as few in-laws as you want.')

      @person.circles.create!(display_name: 'Acquaintances',
                              content: "A good place to stick people you've met but aren't particularly close to.")

      @person.circles.create!(display_name: 'Following',
                              content: "People you don't know personally, but whose posts you find interesting.")
    end
  end
end
