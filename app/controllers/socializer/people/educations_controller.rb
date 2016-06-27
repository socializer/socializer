# frozen_string_literal: true
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

      # GET /people/1/educations/new
      def new
        @education = educations.new
      end

      # GET /people/1/educations/1/edit
      def edit
        @education = find_education
      end

      # POST /people/1/educations
      def create
        @education = educations.create!(params[:person_education])

        redirect_to current_user
      end

      # PATCH/PUT /people/1/educations/1
      def update
        @education = find_education
        @education.update!(params[:person_education])

        redirect_to current_user
      end

      # DELETE /people/1/educations/1
      def destroy
        @education = find_education
        @education.destroy

        redirect_to current_user
      end

      private

      def educations
        @educations ||= current_user.educations
      end

      def find_education
        educations.find_by(id: params[:id])
      end
    end
  end
end
