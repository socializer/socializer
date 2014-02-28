# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_activity_object, class: Socializer::ActivityObject do
    association :activitable, factory: :socializer_note

    factory :socializer_activity_object_activity, class: Socializer::ActivityObject do
      association :activitable, factory: :socializer_activity
    end

    factory :socializer_activity_object_circle, class: Socializer::ActivityObject do
      association :activitable, factory: :socializer_circle
    end

    factory :socializer_activity_object_comment, class: Socializer::ActivityObject do
      association :activitable, factory: :socializer_comment
    end

    factory :socializer_activity_object_group, class: Socializer::ActivityObject do
      association :activitable, factory: :socializer_group
    end

    factory :socializer_activity_object_person, class: Socializer::ActivityObject do
      association :activitable, factory: :socializer_person
    end
  end
end
