# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :authentication, class: Socializer::Authentication do
    provider { "identity" }
    uid { "1" }
    association :person, factory: :person
  end
end
