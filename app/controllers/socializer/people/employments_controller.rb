# frozen_string_literal: true

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
        employment = employments.build(params[:person_employment])

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

        if employment.update(params[:person_employment])
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

      def employments
        @employments ||= current_user.employments
      end

      def find_employment
        @find_employment ||= employments.find_by(id: params[:id])
      end
    end
  end
end
