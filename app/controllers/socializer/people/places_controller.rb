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
        place = places.build(person_place_params)

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

        if place.update(person_place_params)
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

      # Returns the ActiveRecord relation of Place records owned by the current user.
      # The result is memoized in `@places` so subsequent calls reuse the cached relation.
      #
      # @return [ActiveRecord::Relation<Person::Place>] the places belonging to `current_user`
      #
      # @example
      #   # Iterate over current user's places
      #   places.each { |p| puts p.city_name }
      #
      #   # Build a new place scoped to the current user
      #   new_place = places.build(city_name: "Portland", current: true)
      def places
        return @places if defined?(@places)

        @places = current_user.places
      end

      # Finds and memoizes the Place record for the current user using `params[:id]`.
      # Uses memoization so repeated calls return the cached record.
      #
      # @return [Person::Place, nil] the found Place or `nil` when no matching record exists
      #
      # @example
      #   # When params[:id] == "42"
      #   find_place
      #   # => #<Person::Place id: 42 ...> or nil
      def find_place
        return @find_place if defined?(@find_place)

        @find_place = places.find_by(id: params[:id])
      end

      # Returns the permitted parameters for a Person::Place.
      #
      # This method centralizes parameter handling for create/update actions so the
      # controller only exposes the allowed attributes to model operations. It uses
      # `params.expect` (application-specific sanitizer) to retrieve the expected
      # `person_place` hash with the permitted keys.
      #
      # @return [Hash] permitted attributes for a Place (keys: :city_name, :current)
      #
      # @example
      #   # When the request body contains:
      #   # { person_place: { city_name: "Portland", current: true } }
      #   person_place_params
      #   # => { "city_name" => "Portland", "current" => true }
      def person_place_params
        params.expect(person_place: %i[city_name current])
      end
    end
  end
end
