# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for grouping related controllers
  #
  module Groups
    # Joinable controller
    class JoinableController < ApplicationController
      before_action :authenticate_user

      # GET /groups/joinable
      def index
        @groups = Group.joinable
      end
    end
  end
end
