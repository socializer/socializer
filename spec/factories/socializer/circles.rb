# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :circle, class: "Socializer::Circle" do
    sequence(:display_name) { |n| "Friends no#{n}" }
    content { "This is some content" }
    association :activity_author, factory: :activity_object_person

    trait :with_ties do
      transient do
        number_of_ties { 1 }
      end

      after :create do |circle, evaluator|
        create_list(:tie, evaluator.number_of_ties, circle:)
      end
    end
  end
end
