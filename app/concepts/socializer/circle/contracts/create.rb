# frozen_string_literal: true

# require "dry/validation"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Circle related objects
  #
  class Circle
    #
    # Namespace for Contract related objects
    #
    module Contracts
      #
      # Contract object for validating Socializer::Circle
      #
      # @example
      #   circle = Socializer::Circle.new
      #   contract = Circle::Contracts::Create.new(record: circle,
      #                                            actor: current_user)
      #   result = contract.call(params)
      class Create < Base::Contract
        # Adds the record keyword argument to the initializer, ensures the type
        # is [Socializer::Circle], creates a private reader, and defaults to
        # Socializer::Circle.new
        option :record, type: Types.Strict(Circle), reader: :private,
                        default: -> { Circle.new }

        # Adds the actor keyword argument to the initializer, ensures the type
        # is [Socializer::Person], and creates a private reader
        option :actor, type: Types.Strict(Person), reader: :private

        params do
          required(:display_name).filled(:string)
          optional(:content).filled(:string)
        end

        # Preferred syntax would be:
        # rule(:display_name).validate(unique1: [:display_name,
        #                              { author_id: actor.id }])
        rule(:display_name) do |context:|
          context[:scope] = { author_id: actor.id }
        end

        rule(:display_name).validate(unique: :display_name)
        # rule(:display_name).validate(unique1: :display_name) do
        #   @_context[:scope] = { author_id: actor.id }
        # end
      end
    end
  end
end
