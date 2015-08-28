#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Profiles controller
    #
    class ProfilesController < ApplicationController
      before_action :authenticate_user

      # POST /people/1/profiles
      def create
        @profile = profiles.create!(params[:person_profile])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/profiles/1
      def update
        @profile = find_person_profile
        @profile.update!(params[:person_profile])

        redirect_to current_user
      end

      # DELETE /people/1/profiles/1
      def destroy
        @profile = find_person_profile
        @profile.destroy

        redirect_to current_user
      end

      private

      def profiles
        @profiles ||= current_user.profiles
      end

      def find_person_profile
        profiles.find_by(id: params[:id])
      end
    end
  end
end
