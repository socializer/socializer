#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    #
    # Restricted controller
    #
    class RestrictedController < ApplicationController
      before_action :authenticate_user

      # GET /groups/restricted
      def index
        @groups = Group.restricted
      end
    end
  end
end
