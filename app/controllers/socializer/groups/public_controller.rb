#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    class PublicController < ApplicationController
      # GET /groups/public
      def index
        @groups = Group.public
      end
    end
  end
end
