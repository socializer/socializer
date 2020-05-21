# frozen_string_literal: true

require "dry/initializer"

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
      class Create < Base::Operation
        # Initializer
        #
        extend Dry::Initializer

        # Adds the actor keyword argument to the initializer, ensures the type
        # is [Socializer::Person], and creates a private reader
        option :actor, type: Types.Strict(Person), reader: :private

        # Creates the [Socializer::Note]
        #
        # @param [Hash] params: the note parameters
        # from the request
        #
        # @return [Socializer::Note]
        def call(params:)
          validated = yield validate(note_params(params))
          note = yield create(validated.to_h)
          notice = yield success_message(note: note)

          Success(note: note, notice: notice)
        end

        private

        def validate(params)
          contract = Note::Contracts::Create.new
          contract.call(params.to_h).to_monad
        end

        def create(params)
          Success(actor.activity_object.notes.create(params))
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
