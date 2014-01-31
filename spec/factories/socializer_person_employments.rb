# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_employment, class: Socializer::PersonEmployment do
    person_id 1
  end
end
