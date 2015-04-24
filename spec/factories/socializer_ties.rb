# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_tie, class: Socializer::Tie do
    association :circle, factory: :socializer_circle
    association :activity_contact, factory: :socializer_activity_object_person
  end
end
