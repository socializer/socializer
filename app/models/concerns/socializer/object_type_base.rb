# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Object Type Base concern
  #
  # Common functionality for the
  # {http://activitystrea.ms/registry/object_types/ Activity Streams}
  # object types
  #
  module ObjectTypeBase
    extend ActiveSupport::Concern

    included do
      attr_accessor :activity_verb, :scope, :object_ids, :activity_target_id

      has_one :activity_object, as: :activitable, dependent: :destroy

      before_create :activity_object_builder
      after_create :append_to_activity_stream
    end

    # Class methods
    #
    module ClassMethods
      # Joins the activity object and retrieves the activity_objects.id
      #
      # @return [ActiveRecord::Relation]
      def guids
        # FIXME: Rails 7.1 - https://github.com/rails/rails/pull/45612 -
        #        Allows using relation name when querying joins/includes
        # joins(:activity_object).select(activity_object: [id:])
        joins(:activity_object).select("socializer_activity_objects.id")
      end
    end

    # Returns the id from the related activity_object
    #
    # @return [Integer]
    def guid
      activity_object.id
    end

    protected

    # REFACTOR: remove the before_create callback. Move the callback to the
    # controller(s)?
    #           Create a Collaborating Object?
    def activity_object_builder
      build_activity_object
    end

    # REFACTOR: remove the after_create callback. Move the callback to the
    # controller(s)?
    #           Create a Collaborating Object
    def append_to_activity_stream
      # the `return if activity_verb.blank?` guard is needed to block the
      # create! method when
      # creating shares, likes, unlikes, etc
      return if activity_verb.blank?

      CreateActivity.new(actor_id: author_id,
                         activity_object_id: guid,
                         target_id: activity_target_id,
                         verb: activity_verb,
                         object_ids:).call
    end
  end
end
