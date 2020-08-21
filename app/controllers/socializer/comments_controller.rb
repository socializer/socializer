# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Comments controller
  #
  class CommentsController < ApplicationController
    before_action :authenticate_user

    # GET /comments/new
    def new
      respond_to do |format|
        format.html do
          render :new, locals: { comment: Comment.new, target_id: params[:id] }
        end
      end
    end

    # POST /comments
    def create
      operation = Comment::Operations::Create.new(actor: current_user)
      result = operation.call(params: comment_params)

      return create_failure(failure: result.failure) if result.failure?

      success = result.success

      flash.notice = success[:notice]
      redirect_to activities_path

      # comment = build_comment

      # if comment.save
      #   notice = t("socializer.model.create", model: "Comment")
      #   redirect_to activities_path, notice: notice
      # else
      #   render :new, locals: { comment: comment,
      #                          target_id: comment.activity_target_id }
      # end
    end

    # GET /comments/1/edit
    def edit
      respond_to do |format|
        format.html do
          render :edit, locals: { comment: find_comment, target_id: nil }
        end
      end
    end

    # PATCH/PUT /comments/1
    def update
      comment = find_comment
      comment.update!(comment_params)

      flash.notice = t("socializer.model.update", model: "Comment")
      redirect_to activities_path
    end

    # DELETE /comments/1
    def destroy
      comment = find_comment
      comment.destroy
      redirect_to activities_path
    end

    private

    def build_comment
      current_user.comments.build(comment_params) do |comment|
        # comment.activity_verb = Types::ActivityVerbs["add"]
        comment.scope = Audience.privacy.find_value(:public)
      end
    end

    def create_failure(failure:)
      @errors = failure.errors.to_h
      comment = build_comment
      # group = current_user.groups.build(group_params)

      render :new, locals: { comment: comment,
                             target_id: comment.activity_target_id }
    end

    def find_comment
      @find_comment ||= current_user.comments.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      # params.require(:comment).permit(:content)
      params.require(:comment).permit(:content).to_h.symbolize_keys
    end
  end
end
