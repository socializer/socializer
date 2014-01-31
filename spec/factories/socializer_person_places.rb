# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_place, class: Socializer::PersonPlace do
    person_id 1
    city_name 'name'
  end
end
