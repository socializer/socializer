module Socializer
  class ActivitiesController < ApplicationController
    
    def index
      @activities = Activity.stream(:provider => params[:provider], :actor_id => params[:id], :viewer_id => current_user.id)
      if params[:provider] == 'circles'
        @circle = Circle.find(params[:id])
        @title = @circle.name
      elsif params[:provider] == 'people'
        @person = Person.find(params[:id])
        @title = @person.display_name  
      elsif params[:provider] == 'groups'
        @group = Group.find(params[:id])
        @title = @group.name       
      else
        @title = "Activity stream"
      end
    end
    
    def audience
      activities = Activity.stream(:provider => 'activities', :actor_id => params[:id], :viewer_id => current_user.id)
      @object_ids = []
      
      activities.each do |activity|
        activity.audiences.each do |audience|
          if audience.scope == 'CIRCLES'
            current_user.circles.each do |circle|
              circle.embedded_contacts.each do |contact|
                @object_ids.push contact
              end
            end
          else
            if audience.embedded_object.embeddable_type == 'Socializer::Circle'
              audience.embedded_object.embeddable.embedded_contacts.each do |contact|
                @object_ids.push contact
              end
            else
              @object_ids.push audience.embedded_object
            end
          end
        end
      end
      
    end
    
    def like
      @embedded_object = EmbeddedObject.find(params[:id])
      @embedded_object.like!(current_user)
      redirect_to stream_path
    end
    
    def unlike
      @embedded_object = EmbeddedObject.find(params[:id])
      @embedded_object.unlike!(current_user)
      redirect_to stream_path
    end
    
    def likes
      activity = Activity.find(params[:id])
      @object_ids = []            
      activity.embedded_object.likes.each do |person|
        @object_ids.push person.embedded_object
      end        
    end
    
    def new_share
      @embedded_object = EmbeddedObject.find(params[:id])
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
      
      if scope == 'PUBLIC' || scope == 'CIRCLES'
        audience             = Audience.new
        audience.activity_id = activity.id       
        audience.scope       = scope        
        audience.save!
      else
        object_ids.each do |object_id|
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
      @activity.destroy
      redirect_to stream_path
    end
  
  end
end
