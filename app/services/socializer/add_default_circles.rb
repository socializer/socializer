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
    # @param person: [Socializer:Person] the person to create the default circles for
    #
    # @return [Socializer:AddDefaultCircles] returns an instance of AddDefaultCircles
    def initialize(person:)
      unless person.is_a?(Socializer::Person)
        message = I18n.t('socializer.errors.messages.wrong_instance_type', argument: 'person', valid_class: Person.name, invalid_class: person.class.name)
        fail(ArgumentError, message)
      end

      @person = person.activity_object
    end

    # Class Methods

    # Invoke the AddDefaultCircles. This is the primary public API method.
    # Add the default circles
    #
    # @param person: [Socializer:Person] the person to create the default circles for
    def self.perform(person:)
      AddDefaultCircles.new(person: person).perform
    end

    # Instance Methods

    # Invoke the AddDefaultCircles instance. This is the primary public API method.
    # Add the default circles
    def perform
      create_circle(display_name: 'Friends',
                    content: 'Your real friends, the ones you feel comfortable sharing private details with.')

      create_circle(display_name: 'Family',
                    content: 'Your close and extended family, with as many or as few in-laws as you want.')

      create_circle(display_name: 'Acquaintances',
                    content: "A good place to stick people you've met but aren't particularly close to.")

      create_circle(display_name: 'Following',
                    content: "People you don't know personally, but whose posts you find interesting.")
    end

    private

    def create_circle(display_name:, content: nil)
      @person.circles.create!(display_name: display_name, content: content)
    end
  end
end
