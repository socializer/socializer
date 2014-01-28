# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_person, class: Socializer::Person do
    avatar_provider 'GRAVATAR'
  end
end
