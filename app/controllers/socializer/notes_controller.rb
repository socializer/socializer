# frozen_string_literal: true

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
      render :new, locals: { note: Note.new,
                             current_id: params[:id],
                             title: nil }
    end

    # POST /notes
    def create
      activity = activity_for_note(note: create_note)

      Notification.create_for_activity(activity.model)

      flash[:notice] = t("socializer.model.create", model: "Note")

      respond_to do |format|
        format.html { redirect_to activities_path }
        format.js do
          render :create, locals: { activity:, note: Note.new,
                                    current_id: nil, title: "Activity stream" }
        end
      end
    end

    # GET /notes/1/edit
    def edit
      render :edit, locals: { note: find_note, current_id: nil, title: nil }
    end

    # PATCH/PUT /notes/1
    def update
      note = find_note
      note.update!(note_params)

      flash[:notice] = t("socializer.model.update", model: "Note")
      redirect_to activities_path
    end

    # DELETE /notes/1
    def destroy
      note = find_note
      activity_guid = activity_for_note(note:).guid
      note.destroy

      respond_to do |format|
        format.html { redirect_to activities_path }
        format.js do
          render :destroy, locals: { activity_guid: }
        end
      end
    end

    private

    def activity_for_note(note:)
      Activity.find_by(activity_object_id: note.guid).decorate
    end

    def find_note
      current_user.activity_object.notes.find_by(id: params[:id])
    end

    def create_note
      current_user.activity_object.notes.create!(note_params) do |note|
        note.object_ids    = note.object_ids.split(",")
        note.activity_verb = "post"
      end
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:activity_verb, :content, :object_ids)
    end
  end
end
