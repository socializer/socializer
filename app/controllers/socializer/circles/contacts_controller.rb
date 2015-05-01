#
# Namespace for the Socializer engine
#
module Socializer
  module Circles
    class ContactsController < ApplicationController
      before_action :authenticate_user

      # GET /circles/contacts
      def index
        @contacts = current_user.contacts
      end
    end
  end
end
