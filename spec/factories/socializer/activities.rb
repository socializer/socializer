# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :activity, class: "Socializer::Activity" do
    association :activity_object
    association :verb
    association :activitable_actor, factory: :activity_object_person
    association :activitable_object, factory: :activity_object
    association :activitable_target, factory: :activity_object_group
  end
end
