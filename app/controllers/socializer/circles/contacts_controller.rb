#
# Namespace for the Socializer engine
#
module Socializer
  module Circles
    class ContactsController < ApplicationController
      # GET /circles/contacts
      def index
        @contacts = current_user.contacts
      end
    end
  end
end
