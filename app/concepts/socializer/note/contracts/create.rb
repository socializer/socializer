# frozen_string_literal: true

require "dry/validation"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Note related objects
  #
  class Note
    #
    # Namespace for Contract related objects
    #
    module Contracts
      #
      # Contract object for vaidating Socializer::Note
      #
      # @example
      #   contract = Note::Contracts::Create.new
      #   result = contract.call(params)
      class Create < Dry::Validation::Contract
        params do
          required(:activity_verb).filled(:string, included_in?: "post")
          # TODO: Consider creating a Type for object_ids
          required(:object_ids).filled do
            str? | int? | each { str? | int? }
          end
          required(:content).filled(:string)
        end
      end
    end
  end
end
