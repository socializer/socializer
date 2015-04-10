#
# Namespace for the Socializer engine
#
module Socializer
  class NotesController < ApplicationController
    before_action :authenticate_user
    before_action :set_note, only: [:edit, :update, :destroy]

    # GET /notes/new
    def new
      @note = Note.new
      @current_id = params[:id]
    end

    # POST /notes
    def create
      note      = create_note
      @activity = Activity.find_by(activity_object_id: note.guid).decorate

      @note       = Note.new
      @current_id = nil
      @title      = 'Activity stream'

      Notification.create_for_activity(@activity.model)

      flash[:notice] = t('socializer.model.create', model: 'Note')

      respond_to do |format|
        format.js
      end
    end

    # GET /notes/1/edit
    def edit
    end

    # PATCH/PUT /notes/1
    def update
      @note.update!(params[:note])

      flash[:notice] = t('socializer.model.update', model: 'Note')
      redirect_to activities_path
    end

    # DELETE /notes/1
    def destroy
      @activity_guid = Activity.find_by(activity_object_id: @note.guid).guid
      @note.destroy
      respond_to do |format|
        format.js
      end
    end

    private

    def set_note
      @note = current_user.activity_object.notes.find_by(id: params[:id])
    end

    def create_note
      current_user.activity_object.notes.create!(params[:note]) do |note|
        note.object_ids    = note.object_ids.split(',')
        note.activity_verb = 'post'
      end
    end
  end
end
