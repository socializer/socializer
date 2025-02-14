# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for handling people-related actions
  #
  module People
    #
    # Likes controller
    #
    class LikesController < ApplicationController
      before_action :authenticate_user

      # GET people/1/likes
      def index
        person = Person.find_by(id: params[:id]).decorate
        likes  = person.likes

        respond_to do |format|
          format.html do
            render :index, locals: { person:, likes: }
          end
        end
      end
    end
  end
end
