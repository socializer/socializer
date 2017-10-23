# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :activity_object, class: Socializer::ActivityObject do
    unread_notifications_count 0
    association :activitable, factory: :note

    factory :activity_object_activity, class: Socializer::ActivityObject do
      association :activitable, factory: :activity
    end

    factory :activity_object_circle, class: Socializer::ActivityObject do
      association :activitable, factory: :circle
    end

    factory :activity_object_comment, class: Socializer::ActivityObject do
      association :activitable, factory: :comment
    end

    factory :activity_object_group, class: Socializer::ActivityObject do
      association :activitable, factory: :group
    end

    factory :activity_object_person, class: Socializer::ActivityObject do
      association :activitable, factory: :person
    end
  end
end
