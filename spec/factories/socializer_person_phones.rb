# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person_phone, class: Socializer::PersonPhone do
    person_id 1
    label 'mobile'
    number '6666666666'
  end
end
