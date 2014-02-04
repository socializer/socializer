# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_activity_object, class: Socializer::ActivityObject do
    association :activitable, factory: :socializer_note
  end
end
