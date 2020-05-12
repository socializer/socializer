# frozen_string_literal: true

# require "dry/validation"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Verb related objects
  #
  class Circle
    #
    # Namespace for Contract related objects
    #
    module Contracts
      #
      # Contract object for vaidating Socializer::Verb
      #
      # @example
      #   circle = Socializer::Circle.new
      #   contract = Circle::Contracts::Create.new(record: circle,
      #                                            actor: current_user)
      #   result = contract.call(params)
      class Create < Base::Contract
        # Adds the actor keyword argument to the initializer, ensures the tyoe
        # is [Socializer::Person], and creates a private reader
        option :actor, Dry::Types["any"].constrained(type: Person),
               reader: :private

        params do
          # display_name is unique scoped to the author_id, not case sensitive
          required(:display_name).filled(:string)
          required(:content).maybe(:string)
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
