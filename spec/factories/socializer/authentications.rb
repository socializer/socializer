# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :authentication, class: "Socializer::Authentication" do
    provider { "identity" }
    uid { "1" }
    person
  end
end
