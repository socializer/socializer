# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_link, class: Socializer::PersonLink do
    person_id 1
    label 'test'
    url 'http://test.org'
  end
end
