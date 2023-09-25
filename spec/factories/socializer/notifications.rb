# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :notification, class: "Socializer::Notification" do
    read { false }

    activity_object { association :activity_object, strategy: :create }
    activity { association :activity, strategy: :create }
  end
end
