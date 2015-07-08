# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_contribution, class: Socializer::PersonContribution do
    label "test"
    url "http://test.org"
    association :person, factory: :socializer_person
  end
end
