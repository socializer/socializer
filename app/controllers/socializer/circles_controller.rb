module Socializer
  class CirclesController < ApplicationController

    before_filter :set_circle, only: [:show, :edit, :update, :destroy]

    def index
      @circles = current_user.circles
    end

    def contacts
      @circles = current_user.circles
    end

    def contact_of
      @circles = current_user.circles
    end

    def find_people
      @circles = current_user.circles
    end

    def show
      @users = Person.all
    end

    def new
      @circle = Circle.new
    end

    def create
      @circle = current_user.circles.build(params[:circle])
      @circle.save!
      redirect_to circles_contacts_path
    end

    def edit
    end

    def update
      @circle.update!(params[:circle])
      redirect_to @circle
    end

    def destroy
      @circle.destroy
      redirect_to circles_contacts_path
    end

    private

    def set_circle
      @circle = current_user.circles.find(params[:id])
    end

  end
end
