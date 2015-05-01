#
# Namespace for the Socializer engine
#
module Socializer
  module Circles
    class ContactOfController < ApplicationController
      before_action :authenticate_user

      # GET /circles/contact_of
      def index
        @contact_of = current_user.contact_of
      end
    end
  end
end
