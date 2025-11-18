# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Authentication model
  #
  # Tracks the authentication provders for each {Socializer::Person person}.
  #
  class Authentication < ApplicationRecord
    # Relationships
    belongs_to :person

    # Validations
    # TODO: Should a person only be allowed to have 1 provider of each type?
    validates :provider, presence: true
    validates :uid, presence: true

    # Callbacks
    before_destroy :make_sure_its_not_the_last_one

    # Named Scopes

    # Class Methods

    # Find authentications with the given provider
    #
    # @param provider [String]
    #
    # @return [ActiveRecord::Relation<Socializer::Authentication>]
    #
    # @example
    #   Socializer::Authentication.with_provider(provider: 'facebook')
    def self.with_provider(provider:)
      where(provider: provider.downcase)
    end

    # Find authentications that do not have the given provider
    #
    # @param provider [String]
    #
    # @return [ActiveRecord::Relation<Socializer::Authentication>]
    #
    # @example
    #   Socializer::Authentication.not_with_provider(provider: 'facebook')
    def self.not_with_provider(provider:)
      where.not(provider: provider.downcase)
    end

    private

    # Ensures a person retains at least one authentication before allowing deletion.
    #
    # This callback runs before the record is destroyed. If the associated person has
    # only a single authentication left, the method adds an error on :base and halts
    # the destroy by throwing `:abort`.
    #
    # @return [void]
    #
    # @example
    #   # If the person has only one authentication, deletion is prevented:
    #   auth = Socializer::Authentication.find(id)
    #   auth.destroy # => false, auth.errors[:base] contains the i18n message
    def make_sure_its_not_the_last_one
      return unless person.authentications.one?

      errors.add(:base, I18n.t(:cannot_delete_last_authentication,
                               scope: "socializer.errors.messages"))
      throw(:abort)
    end
  end
end
