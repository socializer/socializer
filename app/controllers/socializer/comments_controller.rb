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

    # GET /comments/1/edit
    def edit
      respond_to do |format|
        format.html do
          render :edit, locals: { comment: find_comment, target_id: nil }
        end
      end
    end

    # POST /comments
    def create
      comment = build_comment

      if comment.save
        notice = t("socializer.model.create", model: "Comment")
        redirect_to activities_path, notice:
      else
        render :new, locals: { comment:,
                               target_id: comment.activity_target_id }
      end
    end

    # PATCH/PUT /comments/1
    def update
      comment = find_comment
      comment.update!(comment_params)

      flash[:notice] = t("socializer.model.update", model: "Comment")
      redirect_to activities_path
    end

    # DELETE /comments/1
    def destroy
      comment = find_comment
      comment.destroy
      redirect_to activities_path
    end

    private

    # Builds a new Comment for the current user using the permitted parameters.
    # Sets default values for the new comment's activity verb and visibility scope.
    #
    # @return [Socializer::Comment] an unsaved Comment instance associated with current_user
    #
    # @example
    #   params = { comment: { content: "Nice post!" } }
    #   build_comment # =>
    #     current_user.comments.build(
    #       content: "Nice post!",
    #       activity_verb: "add",
    #       scope: Audience.privacy.find_value(:public)
    #     )
    def build_comment
      current_user.comments.build(comment_params) do |comment|
        comment.activity_verb = "add"
        comment.scope = Audience.privacy.find_value(:public)
      end
    end

    # Finds the comment owned by the current user matching `params[:id]`.
    #
    # This method memoizes the result in `@find_comment` so repeated calls within
    # the same request do not issue additional database queries.
    #
    # @return [Socializer::Comment, nil] the comment if found, otherwise `nil`
    #
    # @example
    #   # params = { id: "42" }
    #   # find_comment # => current_user.comments.find_by(id: "42")
    def find_comment
      return @find_comment if defined?(@find_comment)

      @find_comment = current_user.comments.find_by(id: params[:id])
    end

    # Returns the permitted parameters for a Comment.
    # Uses strong parameters to require a `:comment` key and permit only `:content`.
    #
    # @return [ActionController::Parameters] filtered parameters with `:content`
    #
    # @example
    #   # params = { comment: { content: "Nice post!" } }
    #   # comment_params => ActionController::Parameters.new(content: "Nice post!").permit(:content)
    def comment_params
      params.expect(comment: [:content])
    end
  end
end
