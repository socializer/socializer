# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person_address, class: Socializer::PersonAddress do
    category :home
    association :person, factory: :person
  end
end
