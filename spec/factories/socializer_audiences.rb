# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :audience, class: Socializer::Audience do
    privacy { :public }
    association :activity, factory: :activity
    association :activity_object, factory: :activity_object
  end
end
