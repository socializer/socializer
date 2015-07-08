#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Authentication model
  #
  # Tracks the authentication provders for each {Socializer::Person person}.
  #
  class Authentication < ActiveRecord::Base
    attr_accessible :provider, :uid, :image_url

    # Relationships
    belongs_to :person

    # Named Scopes
    scope :by_provider, -> provider { where(provider: provider.downcase) }
    scope :by_not_provider, -> provider { where.not(provider: provider.downcase) }

    # Validations
    # TODO: Should a person only be allowed to have 1 provider of each type?
    validates :person, presence: true
    validates :provider, presence: true
    validates :uid, presence: true

    # Callbacks
    before_destroy :make_sure_its_not_the_last_one

    private

    def make_sure_its_not_the_last_one
      return unless person.authentications.count == 1

      errors.add(:base, I18n.t("socializer.errors.messages.cannot_delete_last_authentication"))
      false
    end
  end
end
