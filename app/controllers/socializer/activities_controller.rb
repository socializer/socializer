module Socializer
  class ActivitiesController < ApplicationController

    def index
      @activities = Activity.stream(:provider => params[:provider], :actor_id => params[:id], :viewer_id => current_user.id)
      @current_id = nil
      if params[:provider] == 'circles'
        @circle = Circle.find(params[:id])
        @title = @circle.name
        @current_id = @circle.guid
      elsif params[:provider] == 'people'
        @person = Person.find(params[:id])
        @title = @person.display_name
        @current_id = @person.guid
      elsif params[:provider] == 'groups'
        @group = Group.find(params[:id])
        @title = @group.name
        @current_id = @group.guid
      else
        @title = "Activity stream"
      end
    end

    def audience
      activities = Activity.stream(:provider => 'activities', :actor_id => params[:id], :viewer_id => current_user.id)

      @object_ids = []
      is_public = false

      activities.each do |activity|
        activity.audiences.each do |audience|
          # In case of CIRCLES audience, add each contacts of every circles
          # of the actor of the activity.
          if audience.scope == 'PUBLIC'
            @object_ids.push audience.scope
            is_public = true
          elsif audience.scope == 'CIRCLES'
            activity.actor.circles.each do |circle|
              circle.activity_contacts.each do |contact|
                @object_ids.push contact
              end
            end
          else
            if audience.activity_object.activitable_type == 'Socializer::Circle'
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
      end

      unless is_public
        activities.each do |activity|
          # The actor of the activity is always part of the audience.
          @object_ids.push activity.activitable_actor
        end
      end

      # Remove any duplicates from the list. It can happen when, for example, someone
      # post a message to itself.
      @object_ids.uniq!

      respond_to do |format|
        format.html { render :layout => false if request.xhr? }
      end

    end

    def like
      @activity_object = ActivityObject.find(params[:id])
      @activity_object.like!(current_user) unless current_user.likes?(@activity_object)
      @activity = @activity_object.activitable
      respond_to do |format|
        format.js
      end
    end

    def unlike
      @activity_object = ActivityObject.find(params[:id])
      @activity_object.unlike!(current_user) if current_user.likes?(@activity_object)
      @activity = @activity_object.activitable
      respond_to do |format|
        format.js
      end
    end

    def likes
      activity = Activity.find(params[:id])
      @object_ids = []
      activity.activity_object.likes.each do |person|
        @object_ids.push person.activity_object
      end

      respond_to do |format|
        format.html { render :layout => false if request.xhr? }
      end

    end

    def new_share
      @activity_object = ActivityObject.find(params[:id])
      render 'share'
    end

    def share

      scope = params[:share][:scope]
      object_ids = params[:share][:object_ids]

      activity           = Activity.new
      activity.actor_id  = current_user.guid
      activity.object_id = params[:share][:activity_id]
      activity.content   = params[:share][:content]
      activity.verb      = 'share'
      activity.save!

      object_ids.split(",").each do |object_id|
        if object_id == 'PUBLIC' || object_id == 'CIRCLES'
          audience             = Audience.new
          audience.activity_id = activity.id
          audience.scope       = object_id
          audience.save!
        else
          audience             = Audience.new
          audience.activity_id = activity.id
          audience.scope       = 'LIMITED'
          audience.object_id   = object_id
          audience.save!
        end
      end

      redirect_to stream_path

    end

    def destroy
      @activity = Activity.find(params[:id])
      @activity_guid = @activity.guid
      @activity.destroy
      respond_to do |format|
        format.js
      end
    end

  end
end
