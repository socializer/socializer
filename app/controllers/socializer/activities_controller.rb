#
# Namespace for the Socializer engine
#
module Socializer
  class ActivitiesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_activity, only: [:audience, :destroy]

    def index
      id       = params.fetch(:id) { nil }
      provider = params.fetch(:provider) { nil }

      @activities = Activity.stream(provider: provider, actor_uid: id, viewer_id: current_user.id).decorate
      @current_id = nil
      @title      = 'Activity stream'
      @note       = Note.new

      set_provider_variables(provider, id)
    end

    def audience
      build_audience

      respond_to do |format|
        format.html { render layout: false if request.xhr? }
      end
    end

    def destroy
      @activity_guid = @activity.guid
      @activity.destroy

      respond_to do |format|
        format.js
      end
    end

    private

    def set_activity
      @activity = Activity.find_by(id: params[:id])
    end

    def set_provider_variables(provider, id)
      return unless %w( circles people groups ).include?(provider)

      value       = "Socializer::#{provider.classify}".constantize.find_by(id: id)
      @title      = value.display_name if value.respond_to?(:display_name)
      @current_id = value.guid

      instance_variable_set("@#{provider.singularize}", value)
    end

    # REFACTOR: Move out of the controller.
    def build_audience
      @object_ids = []

      @activity.audiences.each do |audience|
        audience_object_ids(audience)
      end

      # The actor of the activity is always part of the audience.
      @object_ids << @activity.activitable_actor unless @object_ids.include?('public')

      # Remove any duplicates from the list. It can happen when, for example, someone
      # post a message to itself.
      @object_ids.uniq!
    end

    # REFACTOR: Move with build_audience and simplify
    def audience_object_ids(audience)
      # In case of CIRCLES audience, add each contacts of every circles
      # of the actor of the activity.
      privacy = audience.privacy

      case privacy
      when privacy.public?
        @object_ids << privacy
      when privacy.circles?
        @activity.actor.circles.each do |circle|
          circle.activity_contacts.each do |contact|
            @object_ids << contact
          end
        end
      else
        activity_object = audience.activity_object

        # The target audience is either a group or a person,
        # which means we can add it as it is in the audience list.
        return @object_ids << activity_object unless activity_object.circle?

        # In the case of LIMITED audience, then go through all the audience
        # circles and add contacts from those circles in the list of allowed
        # audience.
        activity_object.activitable.activity_contacts.each do |contact|
          @object_ids << contact
        end
      end
    end
  end
end
