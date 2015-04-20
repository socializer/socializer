#
# Namespace for the Socializer engine
#
module Socializer
  module People
    class LikesController < ApplicationController
      # GET people/1/likes
      def index
        @person = Person.find_by(id: params[:id]).decorate
        @likes  = @person.likes
      end
    end
  end
end
