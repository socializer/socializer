module Socializer
  class CirclesController < ApplicationController
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
      @circle = current_user.circles.find(params[:id])
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
      @circle = current_user.circles.find(params[:id])
    end

    def update
      @circle = current_user.circles.find(params[:id])
      @circle.update!(params[:circle])
      redirect_to @circle
    end

    def destroy
      @circle = current_user.circles.find(params[:id])
      @circle.destroy
      redirect_to circles_contacts_path
    end
  end
end
