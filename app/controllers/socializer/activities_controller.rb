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

      add_provider_variables(provider.singularize, id) if %w( circles people groups ).include?(provider)
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

    def add_provider_variables(provider, id)
      value       = "Socializer::#{provider.classify}".constantize.find_by(id: id)
      @title      = value.name if value.respond_to?(:name)
      @title      = value.display_name if value.respond_to?(:display_name)
      @current_id = value.guid

      instance_variable_set("@#{provider}", value)
    end

    # REFACTOR: Move out of the controller.
    def build_audience
      @object_ids = []

      @activity.audiences.each do |audience|
        add_audience_object_ids(audience)
      end

      # The actor of the activity is always part of the audience.
      @object_ids << @activity.activitable_actor unless @object_ids.include?('public')

      # Remove any duplicates from the list. It can happen when, for example, someone
      # post a message to itself.
      @object_ids.uniq!
    end

    # REFACTOR: Move with build_audience and simplify
    def add_audience_object_ids(audience)
      # In case of CIRCLES audience, add each contacts of every circles
      # of the actor of the activity.
      privacy = audience.privacy
      if privacy.public?
        @object_ids << privacy
      elsif privacy.circles?
        @activity.actor.circles.each do |circle|
          circle.activity_contacts.each do |contact|
            @object_ids << contact
          end
        end
      else
        activity_object = audience.activity_object
        if activity_object.circle?
          # In the case of LIMITED audience, then go through all the audience
          # circles and add contacts from those circles in the list of allowed
          # audience.
          activity_object.activitable.activity_contacts.each do |contact|
            @object_ids << contact
          end
        else
          # Otherwise, the target audience is either a group or a person,
          # which means we can add it as it is in the audience list.
          @object_ids << activity_object
        end
      end
    end
  end
end
