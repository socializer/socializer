#
# Namespace for the Socializer engine
#
module Socializer
  module Circles
    class FindContactsController < ApplicationController
      before_action :authenticate_user

      # GET /circles/find_contacts
      def index
        @people = Person.all
      end
    end
  end
end
