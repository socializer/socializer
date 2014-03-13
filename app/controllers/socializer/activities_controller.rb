module Socializer
  class ActivitiesController < ApplicationController
    before_action :authenticate_user!

    def index
      id       = params.fetch(:id) { nil }
      provider = params.fetch(:provider) { nil }

      @activities = Activity.stream(provider: provider, actor_uid: id, viewer_id: current_user.id).decorate
      @current_id = nil
      @title      = 'Activity stream'

      if %w( circles people groups ).include?(provider)
        variable    = provider.singularize
        value       = "Socializer::#{variable.classify}".constantize.find_by(id: id)
        @title      = value.name if value.respond_to?(:name)
        @title      = value.display_name if value.respond_to?(:display_name)
        @current_id = value.guid

        instance_variable_set("@#{variable}", value)
      end
    end

    # TODO: Cleanup the commented out code
    def audience
      activity = Activity.find_by(id: params[:id])

      # activities = Activity.stream(provider: 'activities', actor_uid: params[:id], viewer_id: current_user.id)

      @object_ids = []
      is_public = false

      # activities.each do |activity|
      activity.audiences.each do |audience|
        # In case of CIRCLES audience, add each contacts of every circles
        # of the actor of the activity.
        if audience.privacy_level.public?
          @object_ids.push audience.privacy_level
          is_public = true
        elsif audience.privacy_level.circles?
          activity.actor.circles.each do |circle|
            circle.activity_contacts.each do |contact|
              @object_ids.push contact
            end
          end
        else
          if audience.activity_object.circle?
            # In the case of LIMITED audience, then go through all the audience
            # circles and add contacts from those circles in the list of allowed
            # audience.
            audience.activity_object.activitable.activity_contacts.each do |contact|
              @object_ids.push contact
            end
          else
            # Otherwise, the target audience is either a group or a person,
            # which means we can add it as it is in the audience list.
            @object_ids.push audience.activity_object
          end
        end
      end
      # end

      unless is_public
        # activities.each do |activity|
        # The actor of the activity is always part of the audience.
        @object_ids.push activity.activitable_actor
        # end
      end

      # Remove any duplicates from the list. It can happen when, for example, someone
      # post a message to itself.
      @object_ids.uniq!

      respond_to do |format|
        format.html { render layout: false if request.xhr? }
      end
    end

    def destroy
      @activity = Activity.find_by(id: params[:id])
      @activity_guid = @activity.guid
      @activity.destroy
      respond_to do |format|
        format.js
      end
    end
  end
end
