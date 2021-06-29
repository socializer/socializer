# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Circles controller
  #
  class CirclesController < ApplicationController
    before_action :authenticate_user

    # GET /circles
    def index
      circles = current_user.circles.decorate

      respond_to do |format|
        format.html { render :index, locals: { circles: circles } }
      end
    end

    # GET /circles/1
    def show
      respond_to do |format|
        format.html { render :show, locals: { circle: find_circle } }
      end
    end

    # GET /circles/new
    def new
      respond_to do |format|
        format.html { render :new, locals: { circle: Circle.new } }
      end
    end

    # GET /circles/1/edit
    def edit
      respond_to do |format|
        format.html { render :edit, locals: { circle: find_circle } }
      end
    end

    # POST /circles
    def create
      circle = current_user.circles.build(circle_params)

      if circle.save
        flash[:notice] = t("socializer.model.create", model: "Circle")
        redirect_to contacts_circles_path
      else
        render :new, locals: { circle: circle }
      end
    end

    # PATCH/PUT /circles/1
    def update
      circle = find_circle
      circle.update!(circle_params)

      flash[:notice] = t("socializer.model.update", model: "Circle")
      redirect_to circle
    end

    # DELETE /circles/1
    def destroy
      circle = find_circle
      circle.destroy
      redirect_to contacts_circles_path
    end

    private

    def find_circle
      @find_circle ||= current_user.circles.find_by(id: params[:id]).decorate
    end

    # Only allow a list of trusted parameters through.
    def circle_params
      params.require(:circle).permit(:display_name, :content)
    end
  end
end
