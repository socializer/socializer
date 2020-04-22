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

      option :record, optional: true

      register_macro(:email_format) do
        unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
          key.failure("not a valid email format")
        end
      end

      register_macro(:unique) do |macro:|
        attr_name = macro.args[0]
        klass = record.class

        unless klass.where.not(id: record.id).where(attr_name => value).empty?
          key.failure("must be unique")
        end
      end
    end
  end
end
