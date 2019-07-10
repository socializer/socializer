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
          # FIXME: The object_ids is causing an issue. should allow integers
          #        too. The Integers should be a valid Circle. Check in a rule.
          #        The str? should also be checked against PRIVACY
          optional(:object_ids).filled do
            included_in?(PRIVACY) |
              array? & each { included_in?(PRIVACY) | int? } | int?
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
