#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Employments controller
    #
    class EmploymentsController < ApplicationController
      before_action :authenticate_user

      # GET /people/1/employments/new
      def new
        @employment = employments.new
      end

      # GET /people/1/addresses/1/edit
      def edit
        @employment = find_employment
      end

      # POST /people/1/employments
      def create
        @employment = employments.create!(params[:person_employment])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/employments/1
      def update
        @employment = find_employment
        @employment.update!(params[:person_employment])

        redirect_to current_user
      end

      # DELETE /people/1/employments/1
      def destroy
        @employment = find_employment
        @employment.destroy

        redirect_to current_user
      end

      private

      def employments
        @employments ||= current_user.employments
      end

      def find_employment
        employments.find_by(id: params[:id])
      end
    end
  end
end
