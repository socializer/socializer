# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person, class: Socializer::Person do
    sequence(:display_name) { |n| "name#{n}" }
    sequence(:email) { |n| "name#{n}@example.com" }
    avatar_provider "GRAVATAR"

    trait :english do
      language "en"
    end

    trait :french do
      language "fr"
    end

    factory :socializer_person_circles, class: Socializer::Person do
      association :activity_object, factory: :socializer_activity_object_circle
    end

    factory :socializer_person_comments, class: Socializer::Person do
      association :activity_object, factory: :socializer_activity_object_comment
    end

    factory :socializer_person_groups, class: Socializer::Person do
      association :activity_object, factory: :socializer_activity_object_group
    end

    factory :socializer_person_notes, class: Socializer::Person do
      association :activity_object, factory: :socializer_activity_object
    end
  end
end
