#
# Namespace for the Socializer engine
#
module Socializer
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment, only: [:edit, :update, :destroy]

    def new
      @comment = Comment.new
    end

    def create
      @comment = current_user.comments.build(params[:comment])
      @comment.activity_verb = 'add'
      # TODO: Is scope needed? Try commenting it out to see what happens
      @comment.scope = Audience.privacy.find_value(:public)
      @comment.save!
      redirect_to stream_path
    end

    def edit
    end

    def update
      @comment.update!(params[:comment])
      redirect_to stream_path
    end

    def destroy
      @comment.destroy
      redirect_to stream_path
    end

    private

    def set_comment
      @comment = current_user.comments.find_by(id: params[:id])
    end
  end
end
