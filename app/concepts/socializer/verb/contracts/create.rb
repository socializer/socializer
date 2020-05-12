# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Verb related objects
  #
  class Verb
    #
    # Namespace for Contract related objects
    #
    module Contracts
      #
      # Contract object for vaidating Socializer::Verb
      #
      # @example
      #   contract = Verb::Contracts::Create.new
      #   result = contract.call(params)
      # class Create < Dry::Validation::Contract
      class Create < Base::Contract
        # Adds the record keyword argument to the initializer, ensures the tyoe
        # is [Socializer::Verb], creates a private reader, and defaults to
        # Socializer::Verb.new
        option :record, Dry::Types["any"].constrained(type: Verb),
               reader: :private, default: proc { Verb.new }

        # TODO: Need to validate case insensitive uniqueness
        params do
          required(:display_name).filled(Types::ActivityVerbs)
        end

        rule(:display_name).validate(unique: :display_name)
      end
    end
  end
end