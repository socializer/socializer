module Socializer
  class Audience < ActiveRecord::Base
    extend Enumerize

    enumerize :privacy_level, in: { public: 1, circles: 2, limited: 3 }, default: :public, predicates: true, scope: true

    attr_accessible :activity_id, :privacy_level

    belongs_to :activity
    belongs_to :activity_object

    validates :activity_id, presence: true, uniqueness: { scope: :activity_object_id }
    validates :privacy_level, presence: true

    def object
      @object ||= activity_object.activitable
    end
  end
end
