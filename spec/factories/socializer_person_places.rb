# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_place, class: Socializer::PersonPlace do
    city_name "name"
    association :person, factory: :socializer_person
  end
end
