# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for handling people-related actions
  #
  module People
    # Profiles controller
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

      # Returns the current user's profiles association, memoized in `@profiles`.
      #
      # Caches the association result on the controller instance to avoid repeated
      # database queries during the same request.
      #
      # @return [ActiveRecord::Relation<Socializer::Profile>] profiles relation for `current_user`
      #
      # @example
      #   # inside controller action
      #   user_profiles = profiles
      #   profile = user_profiles.build(display_name: "Alice", url: "https://example.com")
      def profiles
        return @profiles if defined?(@profiles)

        @profiles = current_user.profiles
      end

      # Finds and memoizes the profile for the current user identified by params[:id].
      #
      # This method queries the `profiles` association and stores the result in
      # `@find_profile` to prevent multiple database lookups during the same request.
      # Returns `nil` when no profile with the given id exists.
      #
      # @return [Socializer::Profile, nil]
      #
      # @example
      #   # inside controller action
      #   profile = find_profile
      #   if profile
      #     render json: profile
      #   else
      #     head :not_found
      #   end
      def find_profile
        return @find_profile if defined?(@find_profile)

        @find_profile = profiles.find_by(id: params[:id])
      end

      # Returns the permitted parameters for a person's profile.
      #
      # Uses `params.expect` to require and permit the `:person_profile` hash with
      # the allowed keys `:display_name` and `:url`.
      #
      # @return [ActionController::Parameters] permitted parameters for creating/updating a Profile
      #
      # @example
      #   # inside controller action
      #   permitted = person_profile_params
      #   profile = profiles.build(permitted)
      def person_profile_params
        params.expect(person_profile: %i[display_name url])
      end
    end
  end
end
