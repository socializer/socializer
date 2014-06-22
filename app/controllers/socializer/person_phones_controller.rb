#
# Namespace for the Socializer engine
#
module Socializer
  class PersonPhonesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_person_phone, only: [:update, :destroy]

    def create
      @person_phone = current_user.phones.build(params[:person_phone])
      @person_phone.save!
      redirect_to current_user
    end

    def update
      @person_phone.update!(params[:person_phone])
      redirect_to current_user
    end

    def destroy
      @person_phone.destroy
      redirect_to current_user
    end

    private

    def set_person_phone
      @person_phone = current_user.phones.find_by(id: params[:id])
    end
  end
end
