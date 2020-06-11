# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Activity related objects
  #
  class Verb
    #
    # Namespace for Operation related objects
    #
    module Operations
      #
      # Service object for creating a Socializer::Verb
      #
      # @example
      #   verb = Verb::Operations::Create.new
      #   verb.call(params: verb_params) do |result|
      #     result.success do |success|
      #       verb = success[:verb]
      #       notice = success[:notice]
      #     end
      #
      #     result.failure do |failure|
      #       @verb = failure[:verb]
      #       @errors = failure[:errors]
      #     end
      #   end
      class Create < Base::Operation
        # Creates the [Socializer::Verb]
        #
        # @param [Hash] params: the verb parameters
        # from the request
        #
        # @return [Socializer::Verb]
        def call(params:)
          validated = yield validate(params)
          verb = yield create(validated.to_h)
          notice = yield success_message(instance: verb, action: "create")

          Success(verb: verb, notice: notice)
        end

        private

        def validate(params)
          contract = Verb::Contracts::Create.new
          contract.call(params).to_monad
        end

        def create(params)
          Success(Verb.create(params))
        end
      end
    end
  end
end
