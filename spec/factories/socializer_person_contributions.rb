# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_contribution, class: Socializer::PersonContribution do
    person_id 1
    label 'test'
    url 'http://test.org'
  end
end
