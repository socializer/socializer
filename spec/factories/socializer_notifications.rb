# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_notification, class: Socializer::Notification do
    read false

    association :activity_object, factory: :socializer_activity_object
    association :activity,        factory: :socializer_activity
  end
end
