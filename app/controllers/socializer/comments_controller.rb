#
# Namespace for the Socializer engine
#
module Socializer
  class CommentsController < ApplicationController
    before_action :authenticate_user
    before_action :set_comment, only: [:edit, :update, :destroy]

    # GET /comments/new
    def new
      @comment = Comment.new
    end

    # POST /comments
    def create
      @comment = current_user.comments.build(params[:comment])
      @comment.activity_verb = 'add'
      # TODO: Is scope needed? Try commenting it out to see what happens
      @comment.scope = Audience.privacy.find_value(:public)
      @comment.save!

      flash[:notice] = t('socializer.model.create', model: 'Comment')
      redirect_to activities_path
    end

    # GET /comments/1/edit
    def edit
    end

    # PATCH/PUT /comments/1
    def update
      @comment.update!(params[:comment])

      flash[:notice] = t('socializer.model.update', model: 'Comment')
      redirect_to activities_path
    end

    # DELETE /comments/1
    def destroy
      @comment.destroy
      redirect_to activities_path
    end

    private

    def set_comment
      @comment = current_user.comments.find_by(id: params[:id])
    end
  end
end
