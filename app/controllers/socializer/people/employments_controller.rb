# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for handling people-related actions
  #
  module People
    # Employments controller
    class EmploymentsController < ApplicationController
      before_action :authenticate_user

      # GET /people/1/employments/new
      def new
        respond_to do |format|
          format.html { render :new, locals: { employment: employments.new } }
        end
      end

      # GET /people/1/addresses/1/edit
      def edit
        respond_to do |format|
          format.html { render :edit, locals: { employment: find_employment } }
        end
      end

      # POST /people/1/employments
      def create
        employment = employments.build(person_employment_params)

        if employment.save
          flash[:notice] = t("socializer.model.create", model: "Employment")
          redirect_to current_user
        else
          render :new
        end
      end

      # PATCH/PUT /people/1/employments/1
      def update
        employment = find_employment

        if employment.update(person_employment_params)
          flash[:notice] = t("socializer.model.update", model: "Employment")
          redirect_to current_user
        else
          render :edit
        end
      end

      # DELETE /people/1/employments/1
      def destroy
        employment = find_employment
        employment.destroy

        flash[:notice] = t("socializer.model.destroy", model: "Employment")
        redirect_to current_user
      end

      private

      # Returns the ActiveRecord relation of employments for the current user.
      # Memoizes the lookup in `@employments` to avoid repeated database queries
      # during the same request.
      #
      # @return [ActiveRecord::Relation<Socializer::Employment>] the current_user's employments
      #
      # @example
      #   # When the current user has employments:
      #   #   employments.count # => 2
      #   #   employments.build(employer_name: "Acme") # => #<Socializer::Employment ...> (unsaved)
      def employments
        return @employments if defined?(@employments)

        @employments = current_user.employments
      end

      # Finds the Employment record belonging to the current user by the `:id` param.
      #
      # This method memoizes the lookup in `@find_employment` to avoid repeated
      # database queries within the same request lifecycle.
      #
      # @return [Socializer::Employment, nil] the found employment or `nil` if not found
      #
      # @example
      #   # When params[:id] is "5" and the current_user has an employment with id 5:
      #   find_employment # => #<Socializer::Employment id: 5, employer_name: "Acme">
      def find_employment
        return @find_employment if defined?(@find_employment)

        @find_employment = employments.find_by(id: params[:id])
      end

      # Return the expected parameters for creating or updating an Employment.
      #
      # This method validates that `params` includes a `person_employment` hash
      # containing the permitted keys used by the Employment model. It delegates
      # validation to the application's `params.expect` helper.
      #
      # @return [Hash] validated `person_employment` parameters
      #
      # @example
      #   # Incoming request params:
      #   {
      #     person_employment: {
      #       employer_name: "Acme Inc.",
      #       job_title: "Software Engineer",
      #       started_on: "2020-01-01",
      #       ended_on: "2023-06-30",
      #       current: false,
      #       job_description: "Developed web applications"
      #     }
      #   }
      #   person_employment_params
      def person_employment_params
        params.expect(person_employment: %i[employer_name job_title started_on
                                            ended_on current job_description])
      end
    end
  end
end
