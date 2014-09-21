#
# Namespace for the Socializer engine
#
module Socializer
  class PeopleController < ApplicationController
    before_action :authenticate_user!
    before_action :set_person, only: [:show, :likes, :message]

    def index
      @people = Person.all.decorate
    end

    def show
    end

    def edit
      @person = current_user
    end

    def update
      current_user.update!(params[:person])

      flash[:notice] = t('socializer.model.update', model: 'Person')
      redirect_to current_user
    end

    # TODO: Should be handled by the likes controller.
    # Used to display the likes in the user profile
    def likes
      @likes = @person.likes
    end

    def message
      @current_id = @person.guid
      @note = Note.new
    end

    private

    def set_person
      @person = Person.find_by(id: params[:id]).decorate
    end
  end
end
