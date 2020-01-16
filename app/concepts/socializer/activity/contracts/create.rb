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
          # optional(:object_ids)
          optional(:object_ids).maybe do
            included_in?(PRIVACY) | int? |
              array? & each { included_in?(PRIVACY) | int? }
            # str? | array? & each do
            #   str? & included_in?(PRIVACY)
            # end
          end
          optional(:content).maybe(:string)
        end

        rule(:object_ids) do
          # byebug
          if value.is_a?(Integer)
            check_circle(id: value, key: key)
            # circle = Circle.find_by(id: value)
            # key.failure("could not be found") if circle.blank?
          end
        end

        rule(:object_ids) do
          if value.is_a?(Array)
            value.each do |item|
              next unless item.is_a?(Integer)

              check_circle(id: item, key: key)
              # circle = Circle.find_by(id: item)
              # key.failure("could not be found") if circle.blank?
            end
          end
        end

        # rule(:object_ids) do
        #   # byebug
        #   if value.is_a?(String)
        #     key.failure("could not be found") if PRIVACY.exclude?(value)
        #   end
        # end

        # rule(:object_ids) do
        #   # byebug
        #   if value.is_a?(Array)
        #     key.failure("could not be found") if (PRIVACY & value).blank?
        #   end
        # end
        private

        def check_circle(id:, key:)
          circle = Circle.find_by(id: id)
          key.failure("could not be found") if circle.blank?
        end
      end
    end
  end
end
