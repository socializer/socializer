# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Comment related objects
  #
  class Comment
    #
    # Namespace for Contract related objects
    #
    module Contracts
      #
      # Contract object for validating Socializer::Comment
      #
      # @example
      #   contract = Comment::Contracts::Create.new
      #   result = contract.call(params)
      class Create < Base::Contract
        VERB = Types::ActivityVerbs["add"].freeze

        params do
          # TODO: Rename :activity_verb to :verb
          required(:activity_verb).filled(:string, included_in?: VERB)
          required(:content).filled(:string)
        end
      end
    end
  end
end
