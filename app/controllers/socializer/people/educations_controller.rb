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
    # Educations controller
    #
    class EducationsController < ApplicationController
      before_action :authenticate_user

      # GET /people/1/educations/new
      def new
        respond_to do |format|
          format.html { render :new, locals: { education: educations.new } }
        end
      end

      # GET /people/1/educations/1/edit
      def edit
        respond_to do |format|
          format.html { render :edit, locals: { education: find_education } }
        end
      end

      # POST /people/1/educations
      def create
        education = educations.build(person_education_params)

        if education.save
          flash[:notice] = t("socializer.model.create", model: "Education")
          redirect_to current_user
        else
          render :new
        end
      end

      # PATCH/PUT /people/1/educations/1
      def update
        education = find_education

        if education.update(person_education_params)
          flash[:notice] = t("socializer.model.update", model: "Education")
          redirect_to current_user
        else
          render :edit
        end
      end

      # DELETE /people/1/educations/1
      def destroy
        education = find_education
        education.destroy

        flash[:notice] = t("socializer.model.destroy", model: "Education")
        redirect_to current_user
      end

      private

      # Returns the current user's collection of Education records, memoized to avoid
      # repeated database lookups within the same request.
      #
      # @return [ActiveRecord::Associations::CollectionProxy<Socializer::Education>]
      #
      # @example
      #   # First call loads from the database, subsequent calls return the memoized value
      #   first_call = educations
      #   second_call = educations
      #   first_call.equal?(second_call) # => true
      def educations
        return @educations if defined?(@educations)

        @educations = current_user.educations
      end

      # Finds and memoizes the current user's Education record by the `:id` param.
      #
      # This method uses memoization to prevent multiple database lookups within
      # the same request. It scopes the lookup to the current user's educations.
      #
      # @return [Socializer::Education, nil] the matching Education record or `nil` if not found
      #
      # @example
      #   # When params[:id] is present and belongs to the current user
      #   # find_education
      #   # => #<Socializer::Education id: 1, school_name: "Acme University", ...>
      #
      #   # When no matching record exists
      #   # find_education
      #   # => nil
      def find_education
        return @find_education if defined?(@find_education)

        @find_education = educations.find_by(id: params[:id])
      end

      # Returns the permitted parameters for creating/updating a person's education.
      #
      # Extracts and whitelists the education-related attributes from the request
      # parameters so they can be safely passed to the model in `create`/`update`.
      #
      # @return [ActionController::Parameters] filtered education parameters
      #
      # @example
      #   # Given:
      #   # params = { person_education: {
      #   #   school_name: "Acme University",
      #   #   major_or_field_of_study: "Computer Science",
      #   #   started_on: "2020-09-01",
      #   #   ended_on: "2024-06-01",
      #   #   current: false,
      #   #   courses_description: "Algorithms, OS"
      #   # } }
      #   #
      #   # Calling:
      #   # person_education_params
      #   #
      #   # Returns the permitted parameters for building/updating an Education record.
      def person_education_params
        params.expect(person_education: %i[school_name major_or_field_of_study
                                           started_on ended_on current
                                           courses_description])
      end
    end
  end
end
