#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    class RestrictedController < ApplicationController
      # GET /groups/restricted
      def index
        @groups = Group.restricted
      end
    end
  end
end
