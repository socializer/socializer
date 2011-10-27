module Socializer
  class NotesController < ApplicationController  
    
    def new
      @note = Note.new
    end
  
    def create
      @note = current_user.embedded_object.notes.build(params[:note])
      @note.activity_verb = 'post'
      @note.save!
      redirect_to stream_path
    end
  
    def edit
      @note = current_user.embedded_object.notes.find(params[:id])
    end
  
    def update
      @note = current_user.embedded_object.notes.find(params[:id])
      @note.update_attributes!(params[:note])
      redirect_to stream_path
    end
    
    def destroy
      @note = current_user.embedded_object.notes.find(params[:id])
      @note.destroy
      redirect_to stream_path
    end
  
  end
end
