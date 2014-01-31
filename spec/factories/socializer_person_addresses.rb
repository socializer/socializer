# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_address, class: Socializer::PersonAddress do
    person_id 1
    category 1
  end
end
