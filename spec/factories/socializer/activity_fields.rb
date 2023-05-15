# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :activity_field, class: "Socializer::ActivityField" do
    content { "This is My Text" }
    association :activity
  end
end
