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

      def educations
        @educations ||= current_user.educations
      end

      def find_education
        @find_education ||= educations.find_by(id: params[:id])
      end

      # Only allow a list of trusted parameters through.
      def person_education_params
        params.require(:person_education)
              .permit(:school_name, :major_or_field_of_study, :started_on,
                      :ended_on, :current, :courses_description)
      end
    end
  end
end
