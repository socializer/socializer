#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    class JoinableController < ApplicationController
      before_action :authenticate_user

      # GET /groups/joinable
      def index
        @groups = Group.joinable
      end
    end
  end
end
