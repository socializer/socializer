# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :verb, class: "Socializer::Verb" do
    sequence(:display_name) { |n| "post#{n}" }
  end
end
