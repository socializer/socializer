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
      # Contract object for vaidating Socializer::Activity
      #
      # @example
      #   contract = Activity::Contracts::Create.new
      #   result = contract.call(params)
      class Create < Dry::Validation::Contract
        PRIVACY = Audience.privacy.values.freeze

        params do
          required(:actor_id).filled(:integer)
          required(:activity_object_id).filled(:integer)
          optional(:target_id).maybe(:integer)
          required(:verb).filled(type?: Verb)
          optional(:object_ids).filled do
            str? | array? & each { included_in?(PRIVACY) }
            # str? | array? & each do
            #   str?  & included_in?(PRIVACY)
            # end
          end
          optional(:content).maybe(:string)
        end
      end
    end
  end
end
