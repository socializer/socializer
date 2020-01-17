# frozen_string_literal: true

require "dry/validation"

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
      class Create < Dry::Validation::Contract
        params do
          required(:display_name).filled(Types::ActivityVerbs)
        end
      end
    end
  end
end
