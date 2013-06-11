# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_activity_field, class: Socializer::ActivityField do
    content "This is My Text"
    association :activity, factory: :socializer_activity
  end
end
