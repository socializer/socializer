#
# Namespace for the Socializer engine
#
module Socializer
  class Identity < OmniAuth::Identity::Models::ActiveRecord
    attr_accessible :name, :email, :password, :password_confirmation

    # Validations
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
  end
end
