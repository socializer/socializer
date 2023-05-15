# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :person_employment, class: "Socializer::Person::Employment" do
    employer_name { "Some Company" }
    started_on { Date.new(2014, 12, 3) }
    ended_on { nil }
    current { true }
    association :person
  end
end
