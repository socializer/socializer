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
      @circles = current_user.circles.decorate
    end

    # GET /circles/1
    def show
      @circle = find_circle
    end

    # GET /circles/new
    def new
      @circle = Circle.new
    end

    # GET /circles/1/edit
    def edit
      @circle = find_circle
    end

    # POST /circles
    def create
      @circle = current_user.circles.build(params[:circle])
      @circle.save!

      flash[:notice] = t("socializer.model.create", model: "Circle")
      redirect_to contacts_circles_path
    end

    # PATCH/PUT /circles/1
    def update
      @circle = find_circle
      @circle.update!(params[:circle])

      flash[:notice] = t("socializer.model.update", model: "Circle")
      redirect_to @circle
    end

    # DELETE /circles/1
    def destroy
      @circle = find_circle
      @circle.destroy
      redirect_to contacts_circles_path
    end

    private

    def find_circle
      current_user.circles.find_by(id: params[:id]).decorate
    end
  end
end
