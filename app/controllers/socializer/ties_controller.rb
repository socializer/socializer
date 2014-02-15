module Socializer
  class TiesController < ApplicationController
    before_action :authenticate_user!

    def create
      @circle = Circle.find(params[:tie][:circle_id])
      @circle.add_contact(params[:tie][:contact_id])
      redirect_to @circle
    end

    def destroy
      @tie = Tie.find(params[:id])
      @circle = @tie.circle
      @tie.destroy
      redirect_to @circle
    end
  end
end
