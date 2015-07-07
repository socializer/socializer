#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Likes controller
    #
    class LikesController < ApplicationController
      before_action :authenticate_user

      # GET people/1/likes
      def index
        @person = Person.find_by(id: params[:id]).decorate
        @likes  = @person.likes
      end
    end
  end
end
