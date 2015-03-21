#
# Namespace for the Socializer engine
#
module Socializer
  class Authentication < ActiveRecord::Base
    attr_accessible :provider, :uid, :image_url

    # Relationships
    belongs_to :person

    # Named Scopes
    scope :by_provider, -> provider { where(provider: provider.downcase) }
    scope :by_not_provider, -> provider { where.not(provider: provider.downcase) }

    # Callbacks
    before_destroy :make_sure_its_not_the_last_one

    private

    def make_sure_its_not_the_last_one
      return unless person.authentications.count == 1
      # TODO: Add translation
      # errors.add(:base, I18n.t('model.validation.cannot_delete_last_authentication'))
      errors.add(:base, 'cannot delete the last authentication available.')
      false
    end
  end
end
