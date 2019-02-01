# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :activity, class: Socializer::Activity do
    association :activity_object, factory: :activity_object, strategy: :create
    association :verb, factory: :verb, strategy: :create
    association :activitable_actor, factory: :activity_object_person, strategy: :create
    association :activitable_object, factory: :activity_object, strategy: :create
    association :activitable_target, factory: :activity_object_group, strategy: :create
  end
end
