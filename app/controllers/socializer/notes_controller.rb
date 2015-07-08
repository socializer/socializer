#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Notes controller
  #
  class NotesController < ApplicationController
    before_action :authenticate_user

    # GET /notes/new
    def new
      @note = Note.new
      @current_id = params[:id]
    end

    # POST /notes
    def create
      @activity   = Activity.find_by(activity_object_id: create_note.guid).decorate
      @note       = Note.new
      @current_id = nil
      @title      = "Activity stream"

      Notification.create_for_activity(@activity.model)

      flash[:notice] = t("socializer.model.create", model: "Note")

      respond_to do |format|
        format.html { redirect_to activities_path }
        format.js
      end
    end

    # GET /notes/1/edit
    def edit
      @note = find_note
    end

    # PATCH/PUT /notes/1
    def update
      @note = find_note
      @note.update!(params[:note])

      flash[:notice] = t("socializer.model.update", model: "Note")
      redirect_to activities_path
    end

    # DELETE /notes/1
    def destroy
      @note = find_note
      @activity_guid = Activity.find_by(activity_object_id: @note.guid).guid
      @note.destroy

      respond_to do |format|
        format.html { redirect_to activities_path }
        format.js
      end
    end

    private

    def find_note
      current_user.activity_object.notes.find_by(id: params[:id])
    end

    def create_note
      current_user.activity_object.notes.create!(params[:note]) do |note|
        note.object_ids    = note.object_ids.split(",")
        note.activity_verb = "post"
      end
    end
  end
end
