module Socializer
  class PeopleController < ApplicationController
    before_action :authenticate_user!
    before_action :set_person, only: [:show, :likes, :message]

    def index
      @people = Person.all
    end

    def show
    end

    def edit
      @person = current_user
    end

    def update
      current_user.update!(params[:person])
      redirect_to current_user
    end

    # TODO: Should be handled by the likes controller.
    # Used to display the likes in the user profile
    def likes
      @likes = @person.likes
    end

    def message
      @current_id = @person.guid
    end

    private

    def set_person
      @person = Person.find(params[:id])
    end
  end
end
