# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_identity, class: Socializer::Identity do
    sequence(:name) { |n| "name#{n}"}
    sequence(:email) { |n| "name#{n}@example.com"}
    sequence(:password) { |n| "foobar"}
    sequence(:password_confirmation) { |n| "foobar"}
  end
end
