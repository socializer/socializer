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
    # Suggestions controller
    #
    class SuggestionsController < ApplicationController
      before_action :authenticate_user

      # GET /circles/suggestions
      def index
        @people = Person.all
      end
    end
  end
end
