# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Identity model
  #
  # Provides a traditional login/password based authentication system
  #
  class Identity < OmniAuth::Identity::Models::ActiveRecord
    attr_accessible :name, :email, :password, :password_confirmation

    # Validations
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
  end
end
