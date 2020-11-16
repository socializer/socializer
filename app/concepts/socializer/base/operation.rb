# frozen_string_literal: true

require "dry/monads"
require "dry/monads/do"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Base namespace
  #
  module Base
    #
    # Base operation class
    #
    class Operation
      include Dry::Monads[:try]

      def self.inherited(operation)
        super

        operation.class_eval do
          include Dry::Monads[:result, :do]
          include Dry::Monads::Do.for(:call)
        end
      end

      private

      def success_message(instance:, action:)
        model = instance.class.name.demodulize
        notice = I18n.t("socializer.model.#{action}", model: model)

        Success(notice)
      end
    end
  end
end
