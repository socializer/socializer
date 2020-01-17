# frozen_string_literal: true

require "dry/validation"

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
      # Contract object for vaidating a share for Socializer::Activity
      #
      # @example
      #   contract = Activity::Contracts::Share.new
      #   result = contract.call(params)
      class Share < Dry::Validation::Contract
        PRIVACY = Audience.privacy.values.freeze

        params do
          required(:actor_id).filled(:integer)
          required(:activity_object_id).filled(:integer)
          required(:verb).filled(:string, included_in?: "share")
          required(:object_ids).filled do
            str? | each { included_in?(PRIVACY) }
          end
          required(:content).maybe(:string)
        end
      end
    end
  end
end
