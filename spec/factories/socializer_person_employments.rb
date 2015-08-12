# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person_employment, class: Socializer::PersonEmployment do
    employer_name "Some Company"
    started_on Date.new(2014, 12, 3)
    association :person, factory: :person
  end
end
