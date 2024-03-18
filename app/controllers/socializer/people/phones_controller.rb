# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  module People
    #
    # Phones controller
    #
    class PhonesController < ApplicationController
      before_action :authenticate_user

      # GET /people/1/phones/new
      def new
        respond_to do |format|
          format.html { render :new, locals: { phone: phones.new } }
        end
      end

      # GET /people/1/phones/1/edit
      def edit
        respond_to do |format|
          format.html { render :edit, locals: { phone: find_phone } }
        end
      end

      # POST /people/1/phones
      def create
        phone = phones.build(person_phone_params)

        if phone.save
          flash[:notice] = t("socializer.model.create", model: "Phone")
          redirect_to current_user
        else
          render :new
        end
      end

      # PATCH/PUT /people/1/phones/1
      def update
        phone = find_phone

        if phone.update(person_phone_params)
          flash[:notice] = t("socializer.model.update", model: "Phone")
          redirect_to current_user
        else
          render :edit
        end
      end

      # DELETE /people/1/phones/1
      def destroy
        phone = find_phone
        phone.destroy

        flash[:notice] = t("socializer.model.destroy", model: "Phone")
        redirect_to current_user
      end

      private

      def phones
        return @phones if defined?(@phones)

        @phones = current_user.phones
      end

      def find_phone
        return @find_phone if defined?(@find_phone)

        @find_phone = phones.find_by(id: params[:id])
      end

      # Only allow a list of trusted parameters through.
      def person_phone_params
        params.require(:person_phone).permit(:label, :number)
      end
    end
  end
end
