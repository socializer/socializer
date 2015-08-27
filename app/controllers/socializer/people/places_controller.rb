#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Places controller
    #
    class PlacesController < ApplicationController
      before_action :authenticate_user

      # POST /people/1/places
      def create
        @place = current_user.places.create!(params[:person_place])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/places/1
      def update
        @place = find_person_place
        @place.update!(params[:person_place])

        redirect_to current_user
      end

      # DELETE /people/1/places/1
      def destroy
        @place = find_person_place
        @place.destroy

        redirect_to current_user
      end

      private

      def find_person_place
        current_user.places.find_by(id: params[:id])
      end
    end
  end
end
