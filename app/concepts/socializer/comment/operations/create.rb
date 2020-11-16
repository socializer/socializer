# frozen_string_literal: true

require "dry/initializer"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Comment related objects
  #
  class Comment
    #
    # Namespace for Operations related objects
    #
    module Operations
      #
      # Service object for creating a Socializer::Comment
      #
      # @example
      #   comment = Comment::Operations::Create.new(actor: current_user)
      #   comment.call(params: comment_params) do |result|
      #     result.success do |success|
      #       comment = success[:comment]
      #       notice = success[:notice]
      #     end
      #
      #     result.failure do |failure|
      #       @comment = failure[:comment]
      #       @errors = failure[:errors]
      #     end
      #   end
      class Create < Base::Operation
        # Initializer
        #
        extend Dry::Initializer

        # Adds the actor keyword argument to the initializer, ensures the type
        # is [Socializer::Person], and creates a private reader
        option :actor, type: Types.Instance(Person), reader: :private

        # Creates the [Socializer::Comment]
        #
        # @param [Hash] params: the comment parameters
        # from the request
        #
        # @return [Socializer::Comment]
        def call(params:)
          validated = yield validate(comment_params(params))
          comment = yield create(validated.to_h)
          notice = yield success_message(instance: comment, action: "create")

          Success(comment: comment, notice: notice)

          # ActiveRecord::Base.transaction do
          #   comment = yield create(validated.to_h)
          #   notice = yield success_message(comment: comment)
          #   activity = Activity.find_by(activity_object_id: comment.guid)
          #   Notification.create_for_activity(activity)

          #   Success(comment: comment, notice: notice)
          # end
        end

        private

        def validate(params)
          contract = Comment::Contracts::Create.new
          contract.call(params.to_h).to_monad
        end

        def create(params)
          # comments = actor.activity_object.comments
          # comment = comments.none

          # ActiveRecord::Base.transaction do
          #   comment = comments.create(params)
          #   activity = Activity.find_by(activity_object_id: comment.guid)
          #   Notification.create_for_activity(activity)
          # end

          # comment.persisted? ? Success(comment) : Failure(comment)
          Try { actor.activity_object.comments.create(params) }.to_result
        end

        def comment_params(params)
          params.merge({ activity_verb: verb })
        end

        # The verb to use when sharing an [Socializer::ActivityObject]
        #
        # @return [String]
        def verb
          Types::ActivityVerbs["add"]
        end
      end
    end
  end
end
