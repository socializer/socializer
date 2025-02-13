# frozen_string_literal: true

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

      # GET /people/1/profiles/new
      def new
        respond_to do |format|
          format.html { render :new, locals: { profile: profiles.new } }
        end
      end

      # GET /people/1/profiles/1/edit
      def edit
        respond_to do |format|
          format.html { render :edit, locals: { profile: find_profile } }
        end
      end

      # POST /people/1/profiles
      def create
        profile = profiles.build(person_profile_params)

        if profile.save
          flash[:notice] = t("socializer.model.create", model: "Profile")
          redirect_to current_user
        else
          render :new
        end
      end

      # PATCH/PUT /people/1/profiles/1
      def update
        profile = find_profile

        if profile.update(person_profile_params)
          flash[:notice] = t("socializer.model.update", model: "Profile")
          redirect_to current_user
        else
          render :edit
        end
      end

      # DELETE /people/1/profiles/1
      def destroy
        profile = find_profile
        profile.destroy

        flash[:notice] = t("socializer.model.destroy", model: "Profile")
        redirect_to current_user
      end

      private

      def profiles
        return @profiles if defined?(@profiles)

        @profiles = current_user.profiles
      end

      def find_profile
        return @find_profile if defined?(@find_profile)

        @find_profile = profiles.find_by(id: params[:id])
      end

      # Only allow a list of trusted parameters through.
      def person_profile_params
        params.expect(person_profile: %i[display_name url])
      end
    end
  end
end
