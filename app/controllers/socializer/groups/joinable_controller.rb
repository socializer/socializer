#
# Namespace for the Socializer engine
#
module Socializer
  module Groups
    class JoinableController < ApplicationController
      # GET /groups/joinable
      def index
        @groups = Group.joinable
      end
    end
  end
end
