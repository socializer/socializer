#
# Namespace for the Socializer engine
#
module Socializer
  class CirclesController < ApplicationController
    before_action :authenticate_user
    before_action :set_circle, only: [:show, :edit, :update, :destroy]

    # GET /circles
    def index
      @circles = current_user.circles.decorate
    end

    # GET /circles/1
    def show
    end

    # GET /circles/new
    def new
      @circle = Circle.new
    end

    # GET /circles/1/edit
    def edit
    end

    # POST /circles
    def create
      @circle = current_user.circles.build(params[:circle])
      @circle.save!

      flash[:notice] = t('socializer.model.create', model: 'Circle')
      redirect_to contacts_circles_path
    end

    # PATCH/PUT /circles/1
    def update
      @circle.update!(params[:circle])

      flash[:notice] = t('socializer.model.update', model: 'Circle')
      redirect_to @circle
    end

    # DELETE /circles/1
    def destroy
      @circle.destroy
      redirect_to contacts_circles_path
    end

    # GET /circles/contact_of
    def contact_of
      @contact_of = current_user.contact_of
    end

    # GET /circles/find_people
    def find_people
      @people = Person.all
    end

    private

    def set_circle
      @circle = current_user.circles.find_by(id: params[:id]).decorate
    end
  end
end
