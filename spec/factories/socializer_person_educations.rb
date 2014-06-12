# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_education, class: Socializer::PersonEducation do
    association :person, factory: :socializer_person
  end
end
