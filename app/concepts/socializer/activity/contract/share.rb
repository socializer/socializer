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
    module Contract
      #
      # Contract object for vaidating a shRE for Socializer::Activity
      #
      # @example
      #   result = Activity::Contract::Share.call(params)
      Share = Dry::Validation.Form do
        required(:activity_object_id).filled(:int?)
        required(:object_ids).each(:str?)
        required(:content).maybe(:str?)
      end
    end
  end
end
