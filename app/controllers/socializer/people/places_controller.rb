# frozen_string_literal: true

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
        respond_to do |format|
          format.html { render :new, locals: { place: places.new } }
        end
      end

      # GET /people/1/places/1/edit
      def edit
        respond_to do |format|
          format.html { render :edit, locals: { place: find_place } }
        end
      end

      # POST /people/1/places
      def create
        place = places.build(params[:person_place])

        if place.save
          flash[:notice] = t("socializer.model.create", model: "Place")
          redirect_to current_user
        else
          render :new
        end
      end

      # PATCH/PUT /people/1/places/1
      def update
        place = find_place

        if place.update(params[:person_place])
          flash[:notice] = t("socializer.model.update", model: "Place")
          redirect_to current_user
        else
          render :edit
        end
      end

      # DELETE /people/1/places/1
      def destroy
        place = find_place
        place.destroy

        flash[:notice] = t("socializer.model.destroy", model: "Place")
        redirect_to current_user
      end

      private

      def places
        @places ||= current_user.places
      end

      def find_place
        @find_place ||= places.find_by(id: params[:id])
      end
    end
  end
end
