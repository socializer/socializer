# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person, class: Socializer::Person do
    sequence(:display_name) { |n| "name#{n}" }
    sequence(:email) { |n| "name#{n}@example.com" }
    avatar_provider 'GRAVATAR'
  end
end
