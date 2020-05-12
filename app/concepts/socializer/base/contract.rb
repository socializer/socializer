# frozen_string_literal: true

require "dry/validation"

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
      Dry::Validation.load_extensions(:monads)

      config.messages.backend = :i18n
      config.messages.default_locale = :en
      config.messages.top_namespace = :socializer


      register_macro(:email_format) do
        unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
          key.failure("not a valid email format")
        end
      end

      register_macro(:unique) do |context:, macro:|
        attr_name = macro.args[0]
        scope = context[:scope]

        klass = record.class
        query = klass.where(klass.arel_table[attr_name].matches(value))
        query = query.merge(klass.where(scope)) if scope

        unless klass.where.not(id: record.id).merge(query).empty?
          message = "'#{value}' must be unique"
          message += " for '#{actor.display_name}" if scope
          key.failure(message)
        end
      end
    end
  end
end
