# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_identity, class: Socializer::Identity do |f|
    f.sequence(:name) { |n| "name#{n}"}
    f.sequence(:email) { |n| "name#{n}@example.com"}
    f.sequence(:password) { |n| "foobar"}
    f.sequence(:password_confirmation) { |n| "foobar"}
  end
end
