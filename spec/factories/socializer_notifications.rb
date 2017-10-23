# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :notification, class: Socializer::Notification do
    read false

    association :activity_object, factory: :activity_object
    association :activity,        factory: :activity
  end
end
