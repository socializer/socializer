# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :identity, class: Socializer::Identity do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "name#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
