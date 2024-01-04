# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :person_profile, class: "Socializer::Person::Profile" do
    display_name { "test" }
    url { "https://test.org" }
    person
  end
end
