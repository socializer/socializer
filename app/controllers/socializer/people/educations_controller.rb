#
# Namespace for the Socializer engine
#
module Socializer
  module People
    class EducationsController < ApplicationController
      before_action :authenticate_user
      before_action :set_person_education, only: [:update, :destroy]

      # POST /people/1/educations
      def create
        @person_education = current_user.educations.build(params[:person_education])
        @person_education.save!
        redirect_to current_user
      end

      # PATCH/PUT /people/1/educations/1
      def update
        @person_education.update!(params[:person_education])
        redirect_to current_user
      end

      # DELETE /people/1/educations/1
      def destroy
        @person_education.destroy
        redirect_to current_user
      end

      private

      def set_person_education
        @person_education = current_user.educations.find_by(id: params[:id])
      end
    end
  end
end
