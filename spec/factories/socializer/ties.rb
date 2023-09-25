# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :tie, class: "Socializer::Tie" do
    circle
    activity_contact factory: %i[activity_object_person]
  end
end
