#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Educations controller
    #
    class EducationsController < ApplicationController
      before_action :authenticate_user

      # POST /people/1/educations
      def create
        @person_education = educations.create!(params[:person_education])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/educations/1
      def update
        @person_education = find_person_education
        @person_education.update!(params[:person_education])

        redirect_to current_user
      end

      # DELETE /people/1/educations/1
      def destroy
        @person_education = find_person_education
        @person_education.destroy

        redirect_to current_user
      end

      private

      def educations
        @educations ||= current_user.educations
      end

      def find_person_education
        current_user.educations.find_by(id: params[:id])
      end
    end
  end
end
