# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Activity related objects
  #
  class Activity
    #
    # Namespace for Contract related objects
    #
    module Contracts
      #
      # Contract object for vaidating a like for a Socializer::Activity
      #
      # @example
      #   contract = Activity::Contracts::Like.new
      #   result = contract.call(params)
      class Unlike < Like
        params do
          required(:verb).filled(:string, included_in?: "unlike")
        end
      end
    end
  end
end
