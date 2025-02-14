# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for grouping related controllers
  #
  module Groups
    #
    # Public controller
    #
    class PublicController < ApplicationController
      before_action :authenticate_user

      # GET /groups/public
      def index
        @groups = Group.public
      end
    end
  end
end
