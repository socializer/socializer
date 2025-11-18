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

    def make_sure_its_not_the_last_one
      return unless person.authentications.one?

      errors.add(:base, I18n.t(:cannot_delete_last_authentication,
                               scope: "socializer.errors.messages"))
      throw(:abort)
    end
  end
end
