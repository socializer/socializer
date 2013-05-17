module Socializer
  class Audience < ActiveRecord::Base
    extend Enumerize

    enumerize :privacy_level, in: { public: 1, circles: 2, limited: 3 }, default: :public, predicates: true, scope: true

    belongs_to :activity,        class_name: 'Activity',       foreign_key: 'activity_id'
    belongs_to :activity_object, class_name: 'ActivityObject', foreign_key: 'object_id'

    validates :privacy_level, :presence => true

    def object
      @object ||= activity_object.activitable
    end
  end
end
