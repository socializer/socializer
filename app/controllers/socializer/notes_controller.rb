# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Notes controller
  class NotesController < ApplicationController
    before_action :authenticate_user

    # GET /notes/new
    def new
      render :new, locals: { note: Note.new,
                             current_id: params[:id],
                             title: nil }
    end

    # GET /notes/1/edit
    def edit
      render :edit, locals: { note: find_note, current_id: nil, title: nil }
    end

    # POST /notes
    def create
      activity = activity_for_note(note: create_note)

      Notification.create_for_activity(activity.model)

      flash.now[:notice] = t("socializer.model.create", model: "Note")

      respond_to do |format|
        format.html { redirect_to activities_path }
        format.js do
          render :create, locals: { activity:, note: Note.new,
                                    current_id: nil, title: "Activity stream" }
        end
      end
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

    # Find the Activity associated with the given Note.
    #
    # @param note [Note] the Note for which to find the associated Activity
    #
    # @return [#decorate, nil] the decorated Activity associated with the note's guid, or `nil` when not found
    #
    # @example
    #   # Given a note with a guid that matches an Activity's activity_object_id:
    #   # note = Note.new(guid: 'abc123')
    #   # activity = activity_for_note(note: note)
    #   # activity.guid # => 'abc123'
    def activity_for_note(note:)
      Activity.find_by(activity_object_id: note.guid).decorate
    end

    # Finds the note belonging to the current user's activity object using the
    # `params[:id]` parameter.
    #
    # @return [Note, nil] the found Note or `nil` when not found
    #
    # @example
    #   # Given params[:id] == '42'
    #   note = find_note
    #   note&.id # => 42
    def find_note
      current_user.activity_object.notes.find_by(id: params[:id])
    end

    # Creates and persists a new Note for the current user's activity_object.
    # Sets the `object_ids` (split from a comma\-separated string) and the
    # `activity_verb` before saving.
    #
    # @return [Note] the created and persisted note
    #
    # @raise [ActiveRecord::RecordInvalid] if validation fails during creation
    #
    # @example
    #   # Assuming params[:note] = { activity_verb: 'post', content: 'Hello', object_ids: '1,2' }
    #   note = create_note
    #   note.persisted? # => true
    def create_note
      current_user.activity_object.notes.create!(note_params) do |note|
        note.object_ids    = note.object_ids.split(",")
        note.activity_verb = "post"
      end
    end

    # Returns the permitted parameters for creating/updating a Note.
    # Uses the controller's `params.expect` contract to ensure required keys are present.
    #
    # @return [ActionController::Parameters] filtered parameters for `:note`
    #
    # @example
    #   # Given incoming params:
    #   # { note: { activity_verb: "post", content: "Hello", object_ids: "1,2,3" } }
    #   # Calling `note_params` will return the permitted `:note` params.
    #   note_params # => { "activity_verb" => "post", "content" => "Hello", "object_ids" => "1,2,3" }
    def note_params
      params.expect(note: %i[activity_verb content object_ids])
    end
  end
end
