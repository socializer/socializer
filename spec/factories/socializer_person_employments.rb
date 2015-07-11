# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person_employment, class: Socializer::PersonEmployment do
    association :person, factory: :person
  end
end
