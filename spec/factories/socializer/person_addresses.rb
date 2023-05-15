# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :person_address, class: "Socializer::Person::Address" do
    category { :home }
    association :person
    line1 { "282 Kevin Brook" }
    city { "Imogeneborough" }
    province_or_state { "California" }
    postal_code_or_zip { "58517" }
    country { "US" }
  end
end
