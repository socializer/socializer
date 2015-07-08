# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_phone, class: Socializer::PersonPhone do
    category :home
    number "6666666666"
    sequence(:label) { |n| n }
    association :person, factory: :socializer_person
  end
end
