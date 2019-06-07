# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :notification, class: Socializer::Notification do
    read { false }

    association :activity_object, factory: :activity_object, strategy: :create
    association :activity,        factory: :activity, strategy: :create
  end
end
