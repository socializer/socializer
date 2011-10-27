module Socializer
  class CirclesController < ApplicationController
    
    def index
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
      redirect_to circles_path
    end
  
    def edit
      @circle = current_user.circles.find(params[:id])
    end
  
    def update
      @circle = current_user.circles.find(params[:id])
      @circle.update_attributes!(params[:circle])
      redirect_to circles_path
    end
    
    def destroy
      @circle = current_user.circles.find(params[:id])
      @circle.destroy
      redirect_to circles_path
    end
  
  end
end
