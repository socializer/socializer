# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :person_contribution, class: "Socializer::Person::Contribution" do
    sequence(:display_name) { |n| "Contribution #{n}" }
    url { "https://test.org" }
    label { :current_contributor }
    person
  end
end
