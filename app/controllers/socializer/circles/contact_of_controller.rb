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
    # Contact Of controller
    #
    class ContactOfController < ApplicationController
      before_action :authenticate_user

      # GET /circles/contact_of
      def index
        @contact_of = current_user.contact_of
      end
    end
  end
end
