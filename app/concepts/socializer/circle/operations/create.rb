# frozen_string_literal: true

require "dry/initializer"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Activity related objects
  #
  class Circle
    #
    # Namespace for Operation related objects
    #
    module Operations
      #
      # Service object for creating a Socializer::Circle
      #
      # @example
      #   circle = Circle::Operations::Create.new(actor: current_user)
      #   circle.call(params: circle_params) do |result|
      #     result.success do |success|
      #       circle = success[:circle]
      #       notice = success[:notice]
      #     end
      #
      #     result.failure do |failure|
      #       @circle = failure[:circle]
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
        option :actor, type: Types.Instance(Person), reader: :private

        # # Adds the contract keyword argument to the initializer, ensures the
        # # type is [Circle::Contracts::Create], and creates a private reader.
        # REVIEW: Should the contract be passed in?
        # option :contract, type: Types.Instance(Circle::Contracts::Create),
        #        reader: :private,
        #        default: -> { Circle::Contracts::Create.new(actor: actor) }

        # Creates the [Socializer::Circle]
        #
        # @param [Hash] params: the circle parameters
        # from the request
        #
        # @return [Socializer::Circle]
        def call(params:)
          validated = yield validate(params)
          circle = yield create(validated.to_h)
          notice = yield success_message(instance: circle, action: "create")

          Success(circle: circle, notice: notice)
        end

        private

        def validate(params)
          contract = Circle::Contracts::Create.new(actor: actor)
          contract.call(params).to_monad
        end

        def create(params)
          circles = actor.activity_object.circles
          Try { circles.create!(params) }.to_result
        end
      end
    end
  end
end
