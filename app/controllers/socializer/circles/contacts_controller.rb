# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for handling circle-related actions
  #
  module Circles
    #
    # Contacts controller
    #
    class ContactsController < ApplicationController
      before_action :authenticate_user

      # GET /circles/contacts
      def index
        @contacts = current_user.contacts
      end
    end
  end
end
