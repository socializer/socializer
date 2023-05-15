# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :person, class: "Socializer::Person" do
    sequence(:display_name) { |n| "name#{n}" }
    sequence(:email) { |n| "name#{n}@example.com" }
    avatar_provider { "GRAVATAR" }

    trait :english do
      language { "en" }
    end

    trait :french do
      language { "fr" }
    end

    factory :person_circles, class: "Socializer::Person" do
      association :activity_object, factory: :activity_object_circle
    end

    factory :person_comments, class: "Socializer::Person" do
      association :activity_object, factory: :activity_object_comment
    end

    factory :person_groups, class: "Socializer::Person" do
      association :activity_object, factory: :activity_object_group
    end

    factory :person_notes, class: "Socializer::Person" do
      association :activity_object
    end
  end
end
