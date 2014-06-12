# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_address, class: Socializer::PersonAddress do
    category :home
    association :person, factory: :socializer_person
  end
end
