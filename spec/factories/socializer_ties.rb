# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tie, class: Socializer::Tie do
    association :circle, factory: :circle
    association :activity_contact, factory: :activity_object_person
  end
end
