# frozen_string_literal: true

require "dry-initializer"
require "dry/monads/result"
require "dry/monads/do/all"
require "dry/matcher/result_matcher"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Activity related objects
  #
  class Verb
    #
    # Namespace for Service related objects
    #
    module Services
      #
      # Service object for creating a Socializer::Verb
      #
      # @example
      #   verb = Verb::Services::Create.new
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
      class Create
        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do::All
        include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

        # Creates the [Socializer::Verb]
        #
        # @param [ActionController::Parameters] params: the verb parameters
        # from the request
        #
        # @return [Socializer::Verb]
        def call(params:)
          validated = yield validate(params)
          verb = yield create(validated.to_h)

          if verb.persisted?
            notice = yield success_message(verb: verb)

            return Success(verb: verb, notice: notice)
          end

          # TODO: Should this use validation errors?
          Failure(verb)
        end

        private

        def validate(params)
          contract = Verb::Contracts::Create.new
          result = contract.call(params)

          if result.success?
            Success(result)
          else
            # result.errors
            # result.errors(full: true).values
            # TODO: Should this use validation errors?
            Failure(verb: Verb.new, errors: result.errors.to_h)
          end
        end

        def create(params)
          verb = Verb.create(params)

          verb.persisted? ? Success(verb) : Failure(verb)
        end

        def success_message(verb:)
          model = verb.class.name.demodulize
          notice = I18n.t("socializer.model.create", model: model)

          Success(notice)
        end
      end
    end
  end
end
