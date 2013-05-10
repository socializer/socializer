module Socializer
  class Identity < OmniAuth::Identity::Models::ActiveRecord
    attr_accessible :name, :email, :password, :password_confirmation
  end
end
