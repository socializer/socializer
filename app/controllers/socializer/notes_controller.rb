module Socializer
  class NotesController < ApplicationController

    def new
      @note = Note.new
      @current_id = params[:id]
    end

    def create
      @note = current_user.activity_object.notes.build(params[:note])
      @note.object_ids = @note.object_ids.split(",")
      @note.activity_verb = 'post'
      @note.save!
      @activity = Activity.find_by(activity_object_id: @note.guid)
      respond_to do |format|
        format.js
      end
    end

    def edit
      @note = current_user.activity_object.notes.find(params[:id])
    end

    def update
      @note = current_user.activity_object.notes.find(params[:id])
      @note.update!(params[:note])
      redirect_to stream_path
    end

    def destroy
      @note = current_user.activity_object.notes.find(params[:id])
      @activity_guid = Activity.find_by(activity_object_id: @note.guid).guid
      @note.destroy
      respond_to do |format|
        format.js
      end
    end

  end
end
