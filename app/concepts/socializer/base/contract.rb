# frozen_string_literal: true

require "dry/validation"

Dry::Validation.load_extensions(:monads)
Dry::Validation.load_extensions(:predicates_as_macros)

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Base namespace
  #
  module Base
    #
    # Base contract class
    #
    class Contract < Dry::Validation::Contract
      import_predicates_as_macros

      config.messages.backend = :i18n
      config.messages.default_locale = :en
      config.messages.top_namespace = :socializer

      # TODO: Do we need a presence/exists macro to see if an id/integer
      # exists in a specified model
      #
      # single association
      # required(:actor_id).filled(is_record?: Person)
      # many association
      # required(:actor_ids).filled(:array?, is_record?: Person)
      #
      # rule(:actor_id).validate(is_record: Person)
      # register_macro(:is_record) do |context:, macro:|
      #   model = record.class
      #   model.where(id: value).any?
      # end

      register_macro(:email_format) do
        unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
          key.failure("not a valid email format")
        end
      end

      register_macro(:unique) do |context:, macro:|
        attr_name = macro.args[0]
        scope = context[:scope]
        # # REVIEW: this works instead of using context
        # scope = { author_id: actor.id } if actor

        model = record.class
        query = model.where(model.arel_table[attr_name].matches(value))
        query = query.merge(model.where(scope)) if scope

        unless model.where.not(id: record.id).merge(query).empty?
          message = "'#{value}' must be unique"
          message += " for '#{actor.display_name}" if scope
          key.failure(message)
        end
      end
    end
  end
end
