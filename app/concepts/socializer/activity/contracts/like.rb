# frozen_string_literal: true

require "dry-validation"

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
      class Like < Dry::Validation::Contract
        params do
          required(:actor_id).filled(:integer)
          required(:activity_object_id).filled(:integer)
          required(:verb).filled(:string, included_in?: "like")
          required(:object_ids)
            .filled(:string, included_in?: Audience.privacy.public.value)
        end
      end
    end
  end
end
