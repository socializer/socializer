module Socializer
  class Audience < ActiveRecord::Base

    belongs_to :activity,        class_name: 'Activity',       foreign_key: 'activity_id'
    belongs_to :activity_object, class_name: 'ActivityObject', foreign_key: 'object_id'

    def object
      @object ||= activity_object.activitable
    end

    validates_inclusion_of :scope, in: %w( PUBLIC CIRCLES LIMITED )

  end
end
