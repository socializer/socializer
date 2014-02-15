module Socializer
  class NotesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_note, only: [:edit, :update, :destroy]

    def new
      @note = Note.new
      @current_id = params[:id]
    end

    def create
      @note = current_user.activity_object.notes.build(params[:note])
      @note.object_ids = @note.object_ids.split(',')
      @note.activity_verb = 'post'
      @note.save!
      @activity = Activity.find_by(activity_object_id: @note.guid)
      Notification.create_for_activity(@activity)
      respond_to do |format|
        format.js
      end
    end

    def edit
    end

    def update
      @note.update!(params[:note])
      redirect_to stream_path
    end

    def destroy
      @activity_guid = Activity.find_by(activity_object_id: @note.guid).guid
      @note.destroy
      respond_to do |format|
        format.js
      end
    end

    private

    def set_note
      @note = current_user.activity_object.notes.find(params[:id])
    end
  end
end
