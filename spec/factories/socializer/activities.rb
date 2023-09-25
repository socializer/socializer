# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :activity, class: "Socializer::Activity" do
    activity_object
    verb
    activitable_actor factory: %i[activity_object_person]
    activitable_object factory: %i[activity_object]
    activitable_target factory: %i[activity_object_group]
  end
end
