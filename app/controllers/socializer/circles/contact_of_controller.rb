#
# Namespace for the Socializer engine
#
module Socializer
  module Circles
    class ContactOfController < ApplicationController
      # GET /circles/contact_of
      def index
        @contact_of = current_user.contact_of
      end
    end
  end
end
