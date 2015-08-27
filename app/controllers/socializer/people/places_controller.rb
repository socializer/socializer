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

      # GET /people/1/places/new
      def new
        @place = places.new
      end

      # GET /people/1/places/1/edit
      def edit
        @place = find_place
      end

      # POST /people/1/places
      def create
        @place = places.create!(params[:person_place])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/places/1
      def update
        @place = find_place
        @place.update!(params[:person_place])

        redirect_to current_user
      end

      # DELETE /people/1/places/1
      def destroy
        @place = find_place
        @place.destroy

        redirect_to current_user
      end

      private

      def places
        @places ||= current_user.places
      end

      def find_place
        places.find_by(id: params[:id])
      end
    end
  end
end
