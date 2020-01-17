# frozen_string_literal: true

require "dry/initializer"
require "dry/monads/result"
require "dry/monads/do/all"
require "dry/matcher/result_matcher"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Note related objects
  #
  class Note
    #
    # Namespace for Operations related objects
    #
    module Operations
      #
      # Service object for creating a Socializer::Note
      #
      # @example
      #   note = Note::Operations::Create.new(actor: current_user)
      #   note.call(params: note_params) do |result|
      #     result.success do |success|
      #       note = success[:note]
      #       notice = success[:notice]
      #     end
      #
      #     result.failure do |failure|
      #       @note = failure[:note]
      #       @errors = failure[:errors]
      #     end
      #   end
      class Create
        # Initializer
        #
        extend Dry::Initializer

        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do::All
        include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

        # Adds the actor keyword argument to the initializer, ensures the tyoe
        # is [Socializer::Person], and creates a private reader
        option :actor, Dry::Types["any"].constrained(type: Person),
               reader: :private

        # Creates the [Socializer::Note]
        #
        # @param [ActionController::Parameters] params: the note parameters
        # from the request
        #
        # @return [Socializer::Note]
        def call(params:)
          validated = yield validate(note_params(params))
          note = yield create(validated.to_h)

          if note.persisted?
            notice = yield success_message(note: note)

            return Success(note: note, notice: notice)
          end

          # TODO: Should this use validation errors?
          Failure(note)
        end

        private

        def validate(params)
          contract = Note::Contracts::Create.new
          result = contract.call(params.to_h)

          if result.success?
            Success(result)
          else
            # result.errors
            # result.errors(full: true).values
            # TODO: Should this use validation errors?
            Failure(note: Note.new, errors: result.errors.to_h)
          end
        end

        def create(params)
          note = actor.activity_object.notes.create(params)

          note.persisted? ? Success(note) : Failure(note)
        end

        def success_message(note:)
          model = note.class.name.demodulize
          notice = I18n.t("socializer.model.create", model: model)

          Success(notice)
        end

        def note_params(params)
          # "content"=>"Test", "object_ids"=>"public" come from the controller
          # note_params = { activity_verb: verb }

          # params.merge(note_params)
          params
        end

        # # The verb to use when sharing an [Socializer::ActivityObject]
        # #
        # # @return [String]
        # def verb
        #   "post"
        # end
      end
    end
  end
end
