module Socializer
  class Audience < ActiveRecord::Base
    extend Enumerize

    enumerize :privacy_level, in: { public: 1, circles: 2, limited: 3 }, default: :public, predicates: true, scope: true

    belongs_to :activity
    belongs_to :activity_object

    validates :privacy_level, :presence => true

    def object
      @object ||= activity_object.activitable
    end
  end
end
