# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_authentication, class: Socializer::Authentication do
    provider 'identity'
    uid '1'
    association :person, factory: :socializer_person
  end
end
