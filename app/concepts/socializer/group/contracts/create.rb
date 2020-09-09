# frozen_string_literal: true

# require "dry/validation"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Group related objects
  #
  class Group
    #
    # Namespace for Contract related objects
    #
    module Contracts
      #
      # Contract object for validating Socializer::Group
      #
      # @example
      #   group = Socializer::Group.new
      #   contract = Group::Contracts::Create.new(record: group,
      #                                            actor: current_user)
      #   result = contract.call(params)
      class Create < Base::Contract
        PRIVACY = Group.privacy.values.freeze

        # Adds the record keyword argument to the initializer, ensures the type
        # is [Socializer::Group], creates a private reader, and defaults to
        # Socializer::Group.new
        option :record, type: Types.Instance(Group), reader: :private,
                        default: -> { Group.new }

        # Adds the actor keyword argument to the initializer, ensures the type
        # is [Socializer::Person], and creates a private reader
        option :actor, type: Types.Instance(Person), reader: :private

        params do
          required(:display_name).filled(:string)
          required(:privacy).filled(:string, included_in?: PRIVACY)
          optional(:tagline).filled(:string)
          optional(:about).filled(:string)
          optional(:location).filled(:string)
        end

        # Preferred syntax would be:
        # rule(:display_name).validate(unique: [:display_name,
        #                              { author_id: actor.id }])
        rule(:display_name) do |context:|
          context[:scope] = { author_id: actor.id }
        end

        rule(:display_name).validate(unique: :display_name)
      end
    end
  end
end
