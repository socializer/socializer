#
# Namespace for the Socializer engine
#
module Socializer
  module People
    class EmploymentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_person_employment, only: [:update, :destroy]

      def create
        @person_employment = current_user.employments.build(params[:person_employment])
        @person_employment.save!
        redirect_to current_user
      end

      def update
        @person_employment.update!(params[:person_employment])
        redirect_to current_user
      end

      def destroy
        @person_employment.destroy
        redirect_to current_user
      end

      private

      def set_person_employment
        @person_employment = current_user.employments.find_by(id: params[:id])
      end
    end
  end
end
