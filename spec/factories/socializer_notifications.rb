# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_notification, class: Socializer::Notification do
    displayed false
    read false

    association :person,   factory: :socializer_person
    association :activity, factory: :socializer_activity
  end
end
