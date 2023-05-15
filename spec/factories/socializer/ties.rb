# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :tie, class: "Socializer::Tie" do
    association :circle
    association :activity_contact, factory: :activity_object_person
  end
end
