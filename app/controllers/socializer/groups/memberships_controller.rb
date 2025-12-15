# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for grouping related controllers
  #
  module Groups
    # TODO: This may belong under people
    #
    # Memberships controller
    class MembershipsController < ApplicationController
      before_action :authenticate_user

      # GET /groups/memberships
      def index
        @memberships = current_user.memberships
      end
    end
  end
end
