# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person_place, class: Socializer::PersonPlace do
    city_name "name"
    current true
    association :person, factory: :person
  end
end
