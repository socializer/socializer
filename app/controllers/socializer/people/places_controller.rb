#
# Namespace for the Socializer engine
#
module Socializer
  module People
    class PlacesController < ApplicationController
      before_action :authenticate_user
      before_action :set_person_place, only: [:update, :destroy]

      def create
        @person_place = current_user.places.build(params[:person_place])
        @person_place.save!
        redirect_to current_user
      end

      def update
        @person_place.update!(params[:person_place])
        redirect_to current_user
      end

      def destroy
        @person_place.destroy
        redirect_to current_user
      end

      private

      def set_person_place
        @person_place = current_user.places.find_by(id: params[:id])
      end
    end
  end
end
