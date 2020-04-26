# frozen_string_literal: true

require "dry/initializer"
require "dry/matcher/result_matcher"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Activity related objects
  #
  class Activity
    #
    # Namespace for Operation related objects
    #
    module Operations
      #
      # Service object for creating a Socializer::Activity
      #
      class Create < Base::Operation
        include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

        CIRCLES_PRIVACY = Socializer::Audience.privacy.circles.value.freeze
        LIMITED_PRIVACY = Socializer::Audience.privacy.limited.value.freeze
        PUBLIC_PRIVACY = Socializer::Audience.privacy.public.value.freeze

        # Initializer
        #
        extend Dry::Initializer

        # Adds the actor keyword argument to the initializer, ensures the tyoe
        # is [Socializer::Person], and creates a private reader
        option :actor, Dry::Types["any"].constrained(type: Person),
               reader: :private

        # Creates the [Socializer::Activity]
        #
        # @param [ActionController::Parameters] params: the activity parameters
        # from the request
        #
        # @return [Socializer::Activity]
        def call(params:)
          attributes = activity_params(params: params)
          validated = yield validate(attributes)
          activity = yield create(validated.to_h)

          Success(activity)
        end

        private

        attr_reader :content, :object_ids

        def validate(params)
          contract = Activity::Contracts::Create.new
          contract.call(params).to_monad
        end

        def create(params)
          activity = Activity.none

          ActiveRecord::Base.transaction do
            activity = Activity.create(params)
            activity.create_activity_field(content: content) if content.present?

            add_audience_to_activity(activity: activity) if object_ids.present?
          end

          activity.persisted? ? Success(activity) : Failure(activity)
        end

        def activity_params(params:)
          @content = params.delete(:content)
          @object_ids = params[:object_ids]
          verb = yield verb(name: params.delete(:verb))

          activity_params = { actor_id: actor.guid,
                              verb: verb }

          params.merge(activity_params)
        rescue NoMethodError => e
          Failure(e.message)

          # {
          #   actor_id: actor_id,
          #   activity_object_id: activity_object_id,
          #   target_id: target_id,
          #   verb: verb(name: verb)
          # }
        end

        # Add an audience to the activity
        #
        # @param activity: [Socializer::Activity] The activity to add the
        # audience to
        def add_audience_to_activity(activity:)
          object_ids_array.each do |audience_id|
            privacy  = audience_privacy(audience_id: audience_id)
            audience = activity.audiences.build(privacy: privacy)

            if privacy == LIMITED_PRIVACY
              # FIXME: can't assign a string to an id field.
              #        Audience.privacy is string based
              audience.activity_object_id = audience_id
            end

            audience.save
          end
        end

        def object_ids_array
          if Set.new([Integer, String]).include?(object_ids.class)
            return object_ids.split(",")
          end

          object_ids
        end

        def audience_privacy(audience_id:)
          not_limited = Set.new(%W[#{PUBLIC_PRIVACY} #{CIRCLES_PRIVACY}])

          return audience_id if not_limited.include?(audience_id)

          LIMITED_PRIVACY
        end

        #
        # The verb to use when creating an [Socializer::ActivityObject]
        #
        # @param [String] name The display name for the verb
        #
        # @return [Socializer::Verb]
        #
        # FIXME: Should return a monad and be called with yield
        def verb(name:)
          contract = Verb::Contracts::Create.new
          result = contract.call(display_name: name).to_monad

          verb = Verb.find_or_create_by(result.success.to_h) if result.success?

          verb.persisted? ? Success(verb) : Failure(Verb.none)
        end
      end
    end
  end
end
