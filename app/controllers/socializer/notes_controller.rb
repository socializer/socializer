# frozen_string_literal: true

require "dry/monads"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Notes controller
  #
  class NotesController < ApplicationController
    include Dry::Monads[:result]

    before_action :authenticate_user

    # GET /notes/new
    def new
      render :new, locals: { note: Note.new,
                             current_id: params[:id],
                             title: nil }
    end

    # POST /notes
    def create
      case create_note
      in Success(result)
        flash.notice = result[:notice]

        respond_to do |format|
          format.html { redirect_to activities_path }
          format.js { create_render_js(activity: result[:activity]) }
        end
      in Failure(result)
        # flash.alert = "Note was not created."
        @errors = result.errors.to_h
        # @user = User.new(user_params)
        # render :new
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

      flash.notice = t("socializer.model.update", model: "Note")
      redirect_to activities_path
    end

    # DELETE /notes/1
    def destroy
      note = find_note
      activity_guid = activity_for_note(note: note).guid
      note.destroy

      respond_to do |format|
        format.html { redirect_to activities_path }
        format.js do
          render :destroy, locals: { activity_guid: activity_guid }
        end
      end
    end

    private

    def activity_for_note(note:)
      Activity.find_by(activity_object_id: note.guid).decorate
    end

    def create_note
      note = Note::Operations::Create.new(actor: current_user)
      note.call(params: note_params)
    end

    def create_render_js(activity:)
      render :create, locals: { activity: activity,
                                note: Note.new, current_id: nil,
                                title: "Activity stream" }
    end

    def find_note
      current_user.activity_object.notes.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def note_params
      params.require(:note).permit(:content,
                                   :object_ids).to_h.symbolize_keys
    end
  end
end
