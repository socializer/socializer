# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Identity model
  #
  # Provides a traditional login/password based authentication system
  class Identity < OmniAuth::Identity::Models::ActiveRecord
    # Validations
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
  end
end
