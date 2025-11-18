# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Add the default circles for the person
  #
  class AddDefaultCircles
    include ActiveModel::Model
    include Utilities::Message

    attr_reader :person

    validates :person, presence: true, type: Socializer::Person

    # Initializes a new instance of AddDefaultCircles
    #
    # @param person [Socializer::Person] the person to create the default circles for
    # @return [Socializer::AddDefaultCircles] returns an instance of AddDefaultCircles
    #
    # @example
    #   Socializer::AddDefaultCircles.new(person: some_person)
    def initialize(person:)
      @person = person

      raise(ArgumentError, errors.full_messages.to_sentence) unless valid?
    end

    # Class Methods

    # Class method to create and invoke an instance of AddDefaultCircles
    #
    # @param person [Socializer::Person] the person to create the default circles for
    # @return [void]
    #
    # @example
    #   Socializer::AddDefaultCircles.call(person: some_person)
    def self.call(person:)
      new(person:).call
    end

    # Instance Methods

    # Invokes the creation of default circles for the person
    #
    # @example
    #   Socializer::AddDefaultCircles.new(person: some_person).call
    def call
      default_circles.each do |display_name, content|
        create_circle(display_name:, content:)
      end
    end

    private

    # Creates a circle for the person with the given display name and content
    #
    # @param display_name [String] the name of the circle
    # @param content [String, nil] the content/description of the circle
    #
    # @example
    #   create_circle(display_name: "Friends", content: "Close friends")
    def create_circle(display_name:, content: nil)
      @person.activity_object.circles.create!(display_name:, content:)
    end

    # Returns a hash of default circles with their respective content
    #
    # @return [Hash] a hash of default circles and their content
    #
    # @example
    #   # Example usage
    #   default_circles
    #   # =>
    #   # {
    #   #   "Friends" => "Your real friends, the ones you feel comfortable sharing private details with.",
    #   #   "Family" => "Your close and extended family, with as many or as few in-laws as you want.",
    #   #   "Acquaintances" => "A good place to stick people you've met but aren't particularly close to.",
    #   #   "Following" => "People you don't know personally, but whose posts you find interesting."
    #   # }
    def default_circles
      {
        "Friends" => friends_content,
        "Family" => family_content,
        "Acquaintances" => acquaintances_content,
        "Following" => following_content
      }
    end

    def acquaintances_content
      I18n.t("socializer.circles.content.acquaintances")
    end

    def family_content
      I18n.t("socializer.circles.content.family")
    end

    def following_content
      I18n.t("socializer.circles.content.following")
    end

    def friends_content
      I18n.t("socializer.circles.content.friends")
    end
  end
end
