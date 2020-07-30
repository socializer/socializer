# frozen_string_literal: true

require "dry/initializer"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Group related objects
  #
  class Group
    #
    # Namespace for Operation related objects
    #
    module Operations
      #
      # Service object for creating a Socializer::Group
      #
      # @example
      #   group = Group::Operations::Create.new(actor: current_user)
      #   group.call(params: group_params) do |result|
      #     result.success do |success|
      #       group = success[:group]
      #       notice = success[:notice]
      #     end
      #
      #     result.failure do |failure|
      #       @group = failure[:group]
      #       @errors = failure[:errors]
      #     end
      #   end
      class Create < Base::Operation
        # Initializer
        #
        extend Dry::Initializer

        # Adds the actor keyword argument to the initializer, ensures the type
        # is [Socializer::Person], and creates a private reader.
        # option :actor, type: Dry::Types["any"].constrained(type: Person),
        #                reader: :private
        option :actor, type: Types.Strict(Person), reader: :private

        # # Adds the contract keyword argument to the initializer, ensures the
        # # type is [Group::Contracts::Create], and creates a private reader.
        # REVIEW: Should the contract be passed in?
        # option :contract, type: Types.Strict(Group::Contracts::Create),
        #        reader: :private,
        #        default: -> { Group::Contracts::Create.new(actor: actor) }

        # Creates the [Socializer::Group]
        #
        # @param [Hash] params: the group parameters
        # from the request
        #
        # @return [Socializer::Group]
        def call(params:)
          validated = yield validate(params)
          group = yield create(validated.to_h)
          notice = yield success_message(instance: group, action: "create")

          Success(group: group, notice: notice)
        end

        private

        def validate(params)
          contract = Group::Contracts::Create.new(actor: actor)
          contract.call(params).to_monad
        end

        def create(params)
          Success(actor.groups.create!(params))

          # TODO: Need this after create is successful. Wrap in a transaction
          # with the group creation.
          # TODO: Remove after_create callback from the model.
          # def add_author_to_members
          #   author.memberships.create!(group_id: id, active: true)
          # end
          # ActiveRecord::Base.transaction do
          #   group = actor.groups.create!(params)
          #   actor.memberships.create!(group_id: group.id, active: true)

          #   group.persisted? ? Success(group) : Failure(Group.none)

          #   # Success(result)
          # end
        end

        # TODO: Need the verb for creating a group?
        # def Verb
        # end
      end
    end
  end
end
