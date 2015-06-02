#
# Namespace for the Socializer engine
#
module Socializer
  class CommentsController < ApplicationController
    before_action :authenticate_user

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
      @comment = find_comment
    end

    # PATCH/PUT /comments/1
    def update
      @comment = find_comment
      @comment.update!(params[:comment])

      flash[:notice] = t('socializer.model.update', model: 'Comment')
      redirect_to activities_path
    end

    # DELETE /comments/1
    def destroy
      @comment = find_comment
      @comment.destroy
      redirect_to activities_path
    end

    private

    def find_comment
      @comment = current_user.comments.find_by(id: params[:id])
    end
  end
end
