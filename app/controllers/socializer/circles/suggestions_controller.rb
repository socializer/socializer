#
# Namespace for the Socializer engine
#
module Socializer
  module Circles
    class SuggestionsController < ApplicationController
      before_action :authenticate_user

      # GET /circles/suggestions
      def index
        @people = Person.all
      end
    end
  end
end
