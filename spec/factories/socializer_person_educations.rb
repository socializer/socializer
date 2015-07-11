# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person_education, class: Socializer::PersonEducation do
    association :person, factory: :person
  end
end
