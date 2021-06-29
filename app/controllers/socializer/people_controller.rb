# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # People controller
  #
  class PeopleController < ApplicationController
    before_action :authenticate_user

    # GET /people
    def index
      @people = Person.all.decorate
    end

    # GET /people/1
    def show
      @person = find_person
    end

    # GET /people/1/edit
    def edit
      @person = current_user
    end

    # PATCH/PUT /people/1
    def update
      current_user.update!(person_params)

      flash[:notice] = t("socializer.model.update", model: "Person")
      redirect_to current_user
    end

    private

    def find_person
      Person.find_by(id: params[:id]).decorate
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person)
            .permit(:display_name, :email, :language, :avatar_provider,
                    :tagline, :introduction, :bragging_rights, :occupation,
                    :skills, :gender, :looking_for_friends,
                    :looking_for_dating, :looking_for_relationship,
                    :looking_for_networking, :birthdate, :relationship,
                    :other_names)
    end
  end
end
